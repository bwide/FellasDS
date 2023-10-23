//
//  PaywallModifiers.swift
//  PDFScanner
//
//  Created by Bruno Fulber Wide on 20/09/23.
//

import Foundation
import SwiftUI
import FellasStoreKit

public extension View {
    func paywallButton() -> some View {
        modifier(PaywallButtonModifier())
    }
    
    func paywallFeature(_ action: SubscriptionStatus.Action) -> some View {
        modifier(PaywallFeatureModifier(action: action))
    }
}

struct PaywallFeatureModifier: ViewModifier {
    
    var action: SubscriptionStatus.Action
    
    @Environment(\.subscriptionStatus) private var subscriptionStatus
    @Environment(\.subscriptionStatusIsLoading) private var subscriptionStatusIsLoading
    
    @State private var isPresentingPaywall: Bool = false
    
    func body(content: Content) -> some View {
        if !subscriptionStatusIsLoading, subscriptionStatus.canPerformAction(action) {
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
            .onChange(of: isPresentingPaywall) {
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
                    Image(systemName: "crown.fill")
                        .foregroundColor(.yellow)
                })
            }
        }
    }
}

