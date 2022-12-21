//
//  MockStoreProvider.swift
//  Instagram Tracker (iOS)
//
//  Created by Bruno Fulber Wide on 23/08/22.
//

import Foundation
import Combine
import StoreKit

struct MockProduct: ProductProvider {
    
    var id: String
    var displayName: String
    var displayIntroductoryOffer: String {
        String(describing: subscriptionIntroductoryOffer)
    }
    var price: Decimal
    let locale: Locale = .current
    
    var subscriptionIntroductoryOffer: Product.SubscriptionPeriod.Unit? = .month
    
    var displayPrice: String {
        let id = locale.currencyCode!
        return price.formatted(.currency(code: id))
    }
    
    var type: Product.ProductType
    var subscriptionStatus: RenewalState?
    var subscriptionPeriod: Product.SubscriptionPeriod.Unit?
    
    static let monthly: MockProduct = .init(id: "plusOneMonth",
                                            displayName: "Monthly",
                                            price: 5,
                                            type: .autoRenewable,
                                            subscriptionPeriod: .month)
    
    static let yearly: MockProduct = .init(id: "plusOneYear",
                                            displayName: "Yearly",
                                            price: 50,
                                            type: .autoRenewable,
                                            subscriptionPeriod: .year)
}

class MockStoreProvider {
    @Published private var subscriptions: [ProductProvider] = []
    @Published private var purchasedSubscriptions: [ProductProvider] = []
    @Published private var userSubscriptionStatus: RenewalState?
    @Published private var error: Error?
    
    init() {
        subscriptions = [
            MockProduct.monthly,
            MockProduct.yearly
        ]
    }
    
    //MARK: - Private
    private let products: [String] = [
        "plusOneMonth",
        "plusOneYear"
    ]
}

extension MockStoreProvider: StoreProviderType {
    var errorPublisher: AnyPublisher<Error?, Never> {
        $error
            .eraseToAnyPublisher()
    }
    
    var subscriptionsPublisher: AnyPublisher<[ProductProvider], Never> {
        $subscriptions
            .eraseToAnyPublisher()
    }
    
    var purchasedSubscriptionsPublisher: AnyPublisher<[ProductProvider], Never> {
        $purchasedSubscriptions
            .eraseToAnyPublisher()
    }
    
    var userSubscriptionStatusPublisher: AnyPublisher<RenewalState?, Never> {
        Just(.subscribed)
            .eraseToAnyPublisher()
    }
    
    func purchase(_ product: ProductProvider) async throws -> Bool? {
        return true
    }

    /// Determine whether the user purchases a given product.
    func isPurchased(_ product: ProductProvider) async throws -> Bool {
        purchasedSubscriptions.contains(product)
    }
    
    func restorePurchases() {
        print("tapped restore")
    }
}


