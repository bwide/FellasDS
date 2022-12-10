//
//  ProductsStore+Mock.swift
//  Instagram Tracker (iOS)
//
//  Created by Bruno Fulber Wide on 21/07/22.
//

import Foundation
import StoreKit

class MockProductsStore: ProductsStore {
    override var subscriptions: [ProductProvider] { [MockMonthProduct(), MockYearProduct()] }
    
    init() { super.init(provider: MockStoreProvider()) }
}


struct MockMonthProduct: ProductProvider {
    var id: String { "premiumMonth"}
    var displayName: String { "Month" }
    var price: Decimal { 4.99 }
    var displayPrice: String { "$4.99" }
    var type: Product.ProductType { .autoRenewable }
    var subscriptionStatus: RenewalState? { .subscribed }
    var subscriptionPeriod: Product.SubscriptionPeriod.Unit? { .month }
}

struct MockYearProduct: ProductProvider {
    var id: String { "premiumYear" }
    var displayName: String { "Year" }
    var price: Decimal { 49.99 }
    var displayPrice: String { "$49.99" }
    var type: Product.ProductType { .autoRenewable }
    var subscriptionStatus: RenewalState? { .subscribed }
    var subscriptionPeriod: Product.SubscriptionPeriod.Unit? { .year }
}
