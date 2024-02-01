//
//  PaywallModifiers.swift
//  PDFScanner
//
//  Created by Bruno Fulber Wide on 20/09/23.
//

import Foundation
import SwiftUI
import FellasStoreKit

public protocol PaywallActionable {
    func canPerformAction(with status: SubscriptionStatus) -> Bool
}

public struct AlwaysPaywallAction: PaywallActionable {
    
    public init() { }
    
    public func canPerformAction(with status: FellasStoreKit.SubscriptionStatus) -> Bool {
        return status == .subscribed
    }
}

public extension View {
    func withPaywallToolbarButton() -> some View {
        modifier(PaywallButtonModifier())
    }
    
    func paywallFeature(_ action: any PaywallActionable) -> some View {
        modifier(PaywallFeatureModifier(action: action))
    }
    
    func paywallButton() -> some View {
        modifier(PaywallFeatureModifier(action: AlwaysPaywallAction(), hideForSubscribedUsers: true))
    }
    
    func withPaywallContent(@PaywallBuilder _ content: () -> PaywallContent) -> some View {
        environment(\.paywallContent, content())
    }
}

struct PaywallFeatureModifier: ViewModifier {
    
    var action: any PaywallActionable
    
    @Environment(\.subscriptionStatus) private var subscriptionStatus
    @Environment(\.subscriptionStatusIsLoading) private var subscriptionStatusIsLoading
    
    @State private var isPresentingPaywall: Bool = false
    
    var hideForSubscribedUsers: Bool = false
    
    func body(content: Content) -> some View {
        if hideForSubscribedUsers && subscriptionStatus == .subscribed {
          EmptyView()
        } else if !subscriptionStatusIsLoading, action.canPerformAction(with: subscriptionStatus) {
            content
        } else {
            content
                .allowsHitTesting(false)
                .contentShape(Rectangle())
                .onTapGesture { isPresentingPaywall = true }
                .sheet(isPresented: $isPresentingPaywall) { Paywall() }
        }
    }
}

struct PaywallModifier: ViewModifier {
    
    @Binding var shouldPresentPaywall: Bool
    var onDismiss: () -> Void
    
    @Environment(\.subscriptionStatus) private var subscriptionStatus
    @Environment(\.subscriptionStatusIsLoading) private var subscriptionStatusIsLoading
    
    @State private var isPresentingPaywall: Bool = false
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresentingPaywall) {
                Paywall()
                    .onDisappear { onDismiss() }
            }
            .onChange(of: shouldPresentPaywall) {
                isPresentingPaywall = !subscriptionStatusIsLoading && subscriptionStatus.shouldShowPaywall && shouldPresentPaywall
            }
            .onChange(of: subscriptionStatusIsLoading) {
                isPresentingPaywall = !subscriptionStatusIsLoading && subscriptionStatus.shouldShowPaywall && shouldPresentPaywall
            }
    }

}

struct PaywallButtonModifier: ViewModifier {
    
    @Environment(\.subscriptionStatus) private var subscriptionStatus
    @Environment(\.subscriptionStatusIsLoading) private var subscriptionStatusIsLoading
    @State private var isPresentingPaywall: Bool = false
    
    func body(content: Content) -> some View {
        content
            .toolbar { toolbar }
            .sheet(isPresented: $isPresentingPaywall) { Paywall() }
    }
    
    @ToolbarContentBuilder
    var toolbar: some ToolbarContent {
        if !subscriptionStatusIsLoading, subscriptionStatus.shouldShowPaywall {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { isPresentingPaywall = true }, label: {
                    PaywallButtonLabel()
                })
            }
        }
    }
}

public struct PaywallButtonLabel: View {
    
    public init() { }
    
    @State var isJiggly: Bool = false
    @AppStorage("promo") var promo = false
    
    var animation: Animation {
        .easeInOut(duration: 0.15)
        .repeatForever(autoreverses: true)
    }
    
    public var body: some View {
        Image(systemName: "crown.fill")
            .foregroundColor(.yellow)
            .rotationEffect(.degrees(isJiggly ? 5 : 0))
            .rotation3DEffect(
                .degrees(-5),
                axis: (x: 0.0, y: -5.0, z: 0.0)
            )
            .animation(
                animation,
                value: isJiggly
            )
            .onAppear {
                isJiggly = promo
            }
            .onChange(of: promo) {
                isJiggly = promo
            }
    }
}

public struct PaywallContentKey: EnvironmentKey {
    public static var defaultValue: PaywallContent?
}

public extension EnvironmentValues {
    var paywallContent: PaywallContent? {
        get { self[PaywallContentKey.self] }
        set { self[PaywallContentKey.self] = newValue }
    }
}

#Preview {
    PaywallButtonLabel()
        .task {
            PromoManager.isPromoActive = true
        }
}
