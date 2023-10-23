//
//  Paywall.swift
//  PDFScanner
//
//  Created by Bruno Fulber Wide on 16/08/23.
//

import Foundation
import SwiftUI
import StoreKit
import FellasStoreKit

public struct Paywall: View {
    
    @Environment(\.subscriptionIDs) private var subscriptionIDs
    
    public init() {}
    
    public var body: some View {
        SubscriptionStoreView(groupID: subscriptionIDs.group)
            .subscriptionStorePolicyDestination(url: privacyPolicy, for: .privacyPolicy)
            .subscriptionStorePolicyDestination(url: termsOfUse, for: .termsOfService)
            .tint(.ds.brand.primary)
    }
}

extension Paywall {
    var privacyPolicy: URL {
        URL(
            string: "https://pages.flycricket.io/better-pdf-scanner/privacy.html"
        )!
    }
    var termsOfUse: URL {
        URL(
            string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula"
        )!
    }
}

public extension View {
    func paywall(isPresented: Binding<Bool>, onDismiss: @escaping () -> Void = {}) -> some View {
        modifier(
            PaywallModifier(shouldPresentPaywall: isPresented, onDismiss: onDismiss)
        )
    }
}

#Preview {
    Paywall()
}
