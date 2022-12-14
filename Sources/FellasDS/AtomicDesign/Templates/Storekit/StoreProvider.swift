//
//  ProductProviders.swift
//  Instagram Tracker (iOS)
//
//  Created by Bruno Fulber Wide on 23/08/22.
//

import Foundation
import Combine
import StoreKit

public typealias Transaction = StoreKit.Transaction
public typealias RenewalInfo = StoreKit.Product.SubscriptionInfo.RenewalInfo
public typealias RenewalState = StoreKit.Product.SubscriptionInfo.RenewalState

public enum StoreError: Error {
    case failedVerification
}

public protocol StoreProviderType {
    var subscriptionsPublisher: AnyPublisher<[ProductProvider], Never> { get }
    var purchasedSubscriptionsPublisher: AnyPublisher<[ProductProvider], Never> { get }
    var userSubscriptionStatusPublisher: AnyPublisher<RenewalState?, Never> { get }
    var errorPublisher: AnyPublisher<Error?, Never> { get }
    
    func purchase(_ product: ProductProvider) async throws -> Bool?
    func isPurchased(_ product: ProductProvider) async throws -> Bool
    func restorePurchases()
}

open class StoreProvider: NSObject {
    
    @Published private var subscriptions: [ProductProvider] = []
    @Published private var purchasedSubscriptions: [ProductProvider] = []
    @Published private var userSubscriptionStatus: RenewalState?
    @Published private var error: Error?
    
    //MARK: - Private
    private var updateListenerTask: Task<Void, Error>? = nil
    private var paymentQueue = SKPaymentQueue.default()

    private let products: [String]

    public init(products: [String]) {
        self.products = products
        super.init()
        paymentQueue.add(self)
        
        //Start a transaction listener as close to app launch as possible so you don't miss any transactions.
        updateListenerTask = listenForTransactions()

        Task {
            //During store initialization, request products from the App Store.
            await requestProducts()

            //Deliver products that the customer purchases.
            await updateCustomerProductStatus()
        }
    }

    deinit {
        updateListenerTask?.cancel()
    }

    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            //Iterate through any transactions that don't come from a direct call to `purchase()`.
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)

                    //Deliver products to the user.
                    await self.updateCustomerProductStatus()

                    //Always finish a transaction.
                    await transaction.finish()
                } catch {
                    //StoreKit has a transaction that fails verification. Don't deliver content to the user.
                    print("Transaction failed verification")
                }
            }
        }
    }

    @MainActor
    func requestProducts() async {
        do {
            //Request products from the App Store using the identifiers that the Products.plist file defines.
            let storeProducts = try await Product.products(for: products)

            var renewableSubscriptions: [ProductProvider] = []

            //Filter the products into categories based on their type.
            for product in storeProducts {
                switch product.type {
                case .autoRenewable: renewableSubscriptions.append(product)
                default:
                    print("Unknown product")
                }
            }

            subscriptions = renewableSubscriptions.sortByPrice()
        } catch {
            print("Failed product request from the App Store server: \(error)")
        }
    }

    /// Check whether the JWS passes StoreKit verification.
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified: throw StoreError.failedVerification
        case .verified(let safe): return safe
        }
    }

    @MainActor
    func updateCustomerProductStatus() async {
        var purchasedSubscriptions: [ProductProvider] = []

        //Iterate through all of the user's purchased products.
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)

                switch transaction.productType {
                case .autoRenewable:
                    if let subscription = subscriptions.first(with: transaction.productID) {
                        purchasedSubscriptions.append(subscription)
                    }
                default:
                    break
                }
            } catch {
                print()
            }
        }

        //Update the store information with the purchased products.
        self.purchasedSubscriptions = purchasedSubscriptions

        // check subscription tier
        userSubscriptionStatus = try? await purchasedSubscriptions.first?.subscriptionStatus
    }
}

extension StoreProvider: StoreProviderType {
    public var errorPublisher: AnyPublisher<Error?, Never> {
        $error
            .eraseToAnyPublisher()
    }
    
    public var subscriptionsPublisher: AnyPublisher<[ProductProvider], Never> {
        $subscriptions
            .eraseToAnyPublisher()
    }
    
    public var purchasedSubscriptionsPublisher: AnyPublisher<[ProductProvider], Never> {
        $purchasedSubscriptions
            .eraseToAnyPublisher()
    }
    
    public var userSubscriptionStatusPublisher: AnyPublisher<RenewalState?, Never> {
        $userSubscriptionStatus
            .eraseToAnyPublisher()
    }
    
    public func purchase(_ product: ProductProvider) async throws -> Bool? {
        guard let product = product as? Product else { return nil }
        
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)

            await updateCustomerProductStatus()
            await transaction.finish()

            return true //TODO isso pode dar merda
        case .userCancelled, .pending:
            return false
        default:
            return nil
        }
    }

    /// Determine whether the user purchases a given product.
    public func isPurchased(_ product: ProductProvider) async throws -> Bool {
        switch product.type {
        case .autoRenewable:
            return purchasedSubscriptions.contains(product)
        default:
            return false
        }
    }
    
    public func restorePurchases() {
        paymentQueue.restoreCompletedTransactions()
    }
}

extension StoreProvider: SKPaymentTransactionObserver {
    public func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        print("\(#function) \(error.localizedDescription)")
        self.error = error
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print(#function)
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased, .restored:
                print("Purchased purchase/restored")
                guard
                    let product = subscriptions.first(with: transaction.payment.productIdentifier),
                    !purchasedSubscriptions.contains(product)
                else { break }
                     
                purchasedSubscriptions.append(product)
                Task {
                    userSubscriptionStatus = try? await purchasedSubscriptions.first?.subscriptionStatus
                }
                
                paymentQueue.finishTransaction(transaction as SKPaymentTransaction)
                break
            case .failed:
                print("Purchased Failed")
                self.error = transaction.error
                paymentQueue.finishTransaction(transaction as SKPaymentTransaction)
                break
            default:
                print("default")
                break
            }
        }
    }
}
