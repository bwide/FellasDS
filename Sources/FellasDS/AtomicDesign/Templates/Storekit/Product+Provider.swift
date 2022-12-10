//
//  Product+Provider.swift
//  Instagram Tracker (iOS)
//
//  Created by Bruno Fulber Wide on 21/07/22.
//

import Foundation
import StoreKit

public protocol ProductProvider {
    var id: String { get }
    var displayName: String { get }
    
    var price: Decimal { get }
    var displayPrice: String { get }
    
    var type: Product.ProductType { get }
    var subscriptionStatus: RenewalState? { get async throws }
    var subscriptionPeriod: Product.SubscriptionPeriod.Unit? { get }
}

extension Product: ProductProvider {
    public var subscriptionStatus: RenewalState? {
        get async throws {
            try await subscription?.status.first?.state
        }
    }
    
    public var subscriptionPeriod: SubscriptionPeriod.Unit? {
        subscription?.subscriptionPeriod.unit
    }
}
