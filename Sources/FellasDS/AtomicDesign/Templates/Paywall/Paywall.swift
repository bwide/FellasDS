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
    
    public static func buildFinalResult<Label: View>(_ component: Label) -> PaywallContent {
        PaywallContent(paywallLabels: AnyView(
            HStack {
                component
                Spacer(minLength: .zero)
            }
        ))
    }
    
    public static func buildBlock<Label1: View>(
        _ label1: Label1
    ) -> some View {
        VStack(alignment: .leading, spacing: .ds.spacing.small) {
            label1
        }
    }
    
    public static func buildBlock<Label1: View, Label2: View>(
        _ label1: Label1,
        _ label2: Label2
    ) -> some View {
        VStack(alignment: .leading, spacing: .ds.spacing.small) {
            label1
            label2
        }
    }
    
    public static func buildBlock<Label1: View, Label2: View, Label3: View>(
        _ label1: Label1,
        _ label2: Label2,
        _ label3: Label3
    ) -> some View {
        VStack(alignment: .leading, spacing: .ds.spacing.small) {
            label1
            label2
            label3
        }
    }
    
    public static func buildBlock<
        Label1: View, Label2: View, Label3: View, Label4: View
    >(
        _ label1: Label1,
        _ label2: Label2,
        _ label3: Label3,
        _ label4: Label4
    ) -> some View {
        VStack(alignment: .leading, spacing: .ds.spacing.small) {
            label1
            label2
            label3
            label4
        }
    }
    
    public static func buildBlock<
        Label1: View, Label2: View, Label3: View, Label4: View, Label5: View
    >(
        _ label1: Label1,
        _ label2: Label2,
        _ label3: Label3,
        _ label4: Label4,
        _ label5: Label5
    ) -> some View {
        VStack(alignment: .leading, spacing: .ds.spacing.small) {
            label1
            label2
            label3
            label4
            label5
        }
    }
}

public struct Paywall: View {
    
    @Environment(\.paywallType) var paywallType
    
    public init() {}
    
    public var body: some View {
        switch paywallType {
        case .adapty: AdaptyPaywall<PaywallService>()
        case .mockAdapty: AdaptyPaywall<PaywallMockService>()
        case .default: StandardPaywall()
        }
    }
}

public struct PaywallContent {
    var paywallLabels: AnyView
}

struct StandardPaywall: View {
    
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

extension StandardPaywall {
    var privacyPolicy: URL {
        URL(
            string: "https://madduck.com/wp-content/uploads/2022/11/Publishing-Privacy-Policy.pdf"
        )!
    }
    var termsOfUse: URL {
        URL(
            string: "https://madduck.com/terms-of-use/"
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
        var adaptyAPIKey: String? = "public_live_8v7C0A1S.5szHELZbG2nprTmjotym"
        
        var group: String = "A3B522EF"
        
        var subscriptions: [String] = [
            "company.fellas.bible.month",
            "company.fellas.bible.month"
        ]
        
        func identify(productID: FellasStoreKit.ProductID) -> FellasStoreKit.SubscriptionStatus {
            productID.starts(with: "fellasds.premium")
            ? .subscribed
            : .notSubscribed
        }
        
        
    }
    
    return NavigationStack {
        Paywall()
            .withPaywallContent(paywallType: .mockAdapty) {
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
