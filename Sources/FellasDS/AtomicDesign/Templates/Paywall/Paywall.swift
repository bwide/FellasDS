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
    public static func buildBlock<Icon: View>(
        _ title: String, _ subtitle: String, _ labels: Label<Text, Icon>...
    ) -> PaywallContent {
        PaywallContent(
            title: title,
            subtitle: subtitle,
            labels: labels.map { AnyView($0) }
        )
    }
}

public struct PaywallContent {
    var title: String
    var subtitle: String
    var labels: [AnyView]
    
    var labelData: Range<Int> { 0..<labels.count }
    
    @ViewBuilder func label(for index: Int) -> some View { labels[index] }
}

public struct Paywall: View {
    
    @Environment(\.paywallContent) private var content
    @Environment(\.subscriptionIDs) private var subscriptionIDs
    @Environment(\.reviewAlertService) private var reviewAlertService
    @Environment(\.dismiss) private var dismiss
    
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
        }
        
    }
    
    @ViewBuilder
    func marketingContent(_ content: PaywallContent) -> some View {
        ZStack {
            Color.ds.brand.primary.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: .ds.spacing.medium) {
                Label(content.title, systemImage: "crown.fill")
                    .textStyle(ds: .largeTitle)
                ForEach(content.labelData, id: \.self) {
                    content.label(for: $0)
                }
                Text(content.subtitle)
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
                "Title"
                "Et natus aut ipsa saepe neque vitae. Veniam in facere nam quam vitae ut. Ipsum quisquam reprehenderit quo quod"
                Label("Label 1", systemImage: "checkmark")
                Label("Label 2", systemImage: "checkmark")
                Label("Label 3", systemImage: "checkmark")
            }
            .withSubscriptionService(
                identifiers: MockSubscriptions(),
                mock: .notSubscribed
            )
    }
}
