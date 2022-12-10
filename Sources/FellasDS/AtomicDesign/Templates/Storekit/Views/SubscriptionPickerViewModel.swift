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
    var selectedProductIndex: Int? { get set }
    var subscriptionReasons: [SubscriptionReason] { get set }
    var products: [ProductProvider] { get }
    
    var tappedPurchase: PassthroughSubject<Void, Never> { get }
    var tappedRestore: PassthroughSubject<Void, Never> { get }
}

public extension SubscriptionPickerViewModelProtocol {
    var selectedProduct: ProductProvider? {
        guard let index = selectedProductIndex else { return nil }
        return products[index]
    }
}

extension SubscriptionPickerViewModelProtocol {
    var subscribeString: String { "subscribe" }
    var restoreString: String { "restore" }
}

class MockSubscriptionPickerViewModel: SubscriptionPickerViewModelProtocol {
        
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
    
    //MARK: - Combine
    var tappedPurchase: PassthroughSubject<Void, Never> = .init()
    var tappedRestore: PassthroughSubject<Void, Never> = .init()
    
    //MARK: - Private
    private var store: ProductsStore = MockProductsStore()
}
