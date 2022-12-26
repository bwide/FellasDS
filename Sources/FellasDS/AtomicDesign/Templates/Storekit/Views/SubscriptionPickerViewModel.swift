//
//  SubscriptionPickerViewModel.swift
//  Instagram Tracker (iOS)
//
//  Created by Bruno Fulber Wide on 22/07/22.
//

import Foundation
import Combine

public struct SubscriptionReason: Identifiable {
    let image: String
    let title: String
    let subtitle: String
    
    public var id = UUID()
    
    public init(image: String, title: String, subtitle: String, id: UUID = UUID()) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.id = id
    }
}

public protocol SubscriptionPickerViewModelProtocol: ObservableObject {
    
    var privacyPolicyURL: URL { get }
    var termsOfUseURL: URL { get }
    
    var selectedProductIndex: Int? { get set }
    var subscriptionReasons: [SubscriptionReason] { get set }
    var products: [ProductProvider] { get }
    
    var isLoading: Bool { get set }
    var error: Error? { get set }
    
    var onTappedPurchase: PassthroughSubject<Void, Never> { get }
    var onTappedRestore: PassthroughSubject<Void, Never> { get }
}

public extension SubscriptionPickerViewModelProtocol {
    var selectedProduct: ProductProvider? {
        guard let index = selectedProductIndex else { return nil }
        return products[index]
    }
    
    var termsOfUseURL: URL { URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/" )! }
}

extension SubscriptionPickerViewModelProtocol {
    var subscribeString: String { .s.subscribe }
    var restoreString: String { .s.restore }
    
    var termsOfUseString: String { .s.termsOfUse }
    var privacyPolicyString: String { .s.privacyPolicy }
}

class MockSubscriptionPickerViewModel: SubscriptionPickerViewModelProtocol {
    
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var selectedProductIndex: Int?
    
    var products: [ProductProvider] { store.subscriptions }
    
    var subscriptionReasons: [SubscriptionReason] = [
            .init(image: "clock.arrow.circlepath",
                  title: "title",
                  subtitle: "subtitle"),
        
            .init(image: "person.fill.badge.minus",
                  title: "title",
                  subtitle: "subtitle"),
    ]
    
    var privacyPolicyURL: URL { URL(string: "www.google.com")! }
    var termsOfUseURL: URL { URL(string: "www.google.com")! }
    
    //MARK: - Combine
    let onTappedPurchase: PassthroughSubject<Void, Never> = .init()
    let onTappedRestore: PassthroughSubject<Void, Never> = .init()
    
    //MARK: - Private
    private var store: ProductsStore = MockProductsStore()
}
