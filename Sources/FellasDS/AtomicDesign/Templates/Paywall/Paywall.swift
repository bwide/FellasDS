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
import Shiny

@resultBuilder
public enum PaywallBuilder {
    public static func buildBlock<Label: View, TextLabel: View>(
        _ text: TextLabel,
        _ labels: Label...
    ) -> PaywallContent {
        PaywallContent(
            paywallLabels: AnyView({
                VStack(alignment: .leading, spacing: .ds.spacing.small) {
                    ForEach(labels.indices, id: \.self) {
                        labels[$0]
                    }
                    text
                }
            }())
        )
    }
}

public struct PaywallContent {
    var paywallLabels: AnyView
}

public struct Paywall: View {
    
    @Environment(\.paywallContent) private var content
    @Environment(\.subscriptionIDs) private var subscriptionIDs
    @Environment(\.reviewAlertService) private var reviewAlertService
    @Environment(\.subscriptionStatus) private var subscriptionStatus
    @Environment(\.dismiss) private var dismiss
    @Environment(\.analytics) private var analytics

    private var paywallID = 1 // TODO
    @State var selection: Product?
    @State var subscriptions: [Product] = []
    
    public init() { }
    
    public var body: some View {
        Group {
            if let content {
                SubscriptionStoreView(
                    productIDs: subscriptionIDs.subscriptions,
                    marketingContent: { marketingContent(content) }
                )
            } else {
                SubscriptionStoreView(
                    productIDs: subscriptionIDs.subscriptions
                )
            }
        }
        .subscriptionStoreControlIcon(icon: { product, info in
            if info.subscriptionPeriod.unit == .year {
                Text(Strings.yearlyDiscount)
                    .font(.headline)
                    .fontWeight(.black)
                    .shiny(.rainbow)
                Spacer()
            }
        })
        .subscriptionStoreButtonLabel(.multiline)
        .subscriptionStoreControlBackground(
            LinearGradient(
                colors: [.ds.brand.primary, .ds.background.tertiary],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .subscriptionStorePolicyDestination(url: privacyPolicy, for: .privacyPolicy)
        .subscriptionStorePolicyDestination(url: termsOfUse, for: .termsOfService)
        .subscriptionStorePolicyForegroundStyle(Color.ds.text.background.primary)
        .storeButton(.visible, for: .restorePurchases)
        .tint(.ds.brand.primary)
        .onDisappear {
            reviewAlertService.presentReviewPrompt()
            switch subscriptionStatus {
            case .subscribed: logSuccess()
            case .notSubscribed: logSkip()
            }
        }
        .onAppear {
            logAppear()
        }
        
    }
    
    @ViewBuilder
    func marketingContent(_ content: PaywallContent) -> some View {
        ZStack {
            Color.ds.brand.primary.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: .ds.spacing.medium) {
                Label(Strings.paywallTitle, systemImage: "crown.fill")
                    .textStyle(ds: .largeTitle)
                content.paywallLabels
            }
            .padding(.horizontal, ds: .large)
            .multilineTextAlignment(.leading)
            .textStyle(ds: .body)
        }
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
    
    var currencyCode: String {
        Locale.current.currency?.identifier ??
        "USD"
    }
    
    var screenProperties: [String: Any] {
        [
            "paywall_id" : paywallID
        ]
    }
    
    func logAppear() {
        analytics.log(event: .init(name: "paywall_s1", properties: screenProperties))
    }
    
    func logSkip() {
        analytics.log(event: .init(name: "paywall_button_skip", properties: screenProperties))
    }
    
    func logSuccess() {
        analytics.log(event: .init(name: "paywall_button_accept", properties: screenProperties))
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
    
    struct MockSubscriptions: SubscriptionIdentifying {
        var group: String = "A3B522EF"
        
        var subscriptions: [String] = [
            "fellasds.premium.month",
            "fellasds.premium.year"
        ]
        
        func identify(productID: FellasStoreKit.ProductID) -> FellasStoreKit.SubscriptionStatus {
            productID.starts(with: "fellasds.premium")
            ? .subscribed
            : .notSubscribed
        }
        
        
    }
    
    return NavigationStack {
        Paywall()
            .withPaywallContent {
                Text(verbatim: "Et natus aut ipsa saepe neque vitae. Veniam in facere nam quam vitae ut. Ipsum quisquam reprehenderit quo quod")
                Label(String(stringLiteral: "Label 1"), systemImage: "checkmark")
                Label(String(stringLiteral: "Label 2"), systemImage: "checkmark")
                Label(String(stringLiteral: "Label 3"), systemImage: "checkmark")
            }
            .withSubscriptionService(
                identifiers: MockSubscriptions(),
                mock: .notSubscribed
            )
    }
}
