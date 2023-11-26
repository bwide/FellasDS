//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 22/10/23.
//

import Foundation
import SwiftUI
import SwiftResources
import FellasStoreKit

public extension View {
    func forceOnboarding(_ value: Bool? = nil) -> some View {
        task {
            guard let value else { return }
            UserDefaults.standard
                .setValue(!value, forKey: "didShowOnboarding")
            PromoManager.isPromoActive = !value
        }
    }
    
    func onboarding(
        force isOnboarding: Bool? = nil,
        @OnboardingContentBuilder _ onboarding: @escaping () -> OnboardingContent,
        onDisappear: @escaping () -> Void = {}
    ) -> some View {
        modifier(OnboardingModifier(onboarding, onDisappear: onDisappear))
            .forceOnboarding(isOnboarding)
    }
}

struct OnboardingModifier: ViewModifier {
    
    var onboarding: () -> OnboardingContent
    var onDisappear: () -> Void
    
    init(
        @OnboardingContentBuilder _ onboarding: @escaping () -> OnboardingContent,
        onDisappear: @escaping () -> Void
    ) {
        self.onboarding = onboarding
        self.onDisappear = onDisappear
    }
    
    @State private var isPresented: Bool = false
    @AppStorage("didShowOnboarding") private var didShowOnboarding: Bool = false
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented, onDismiss: onDismissOnboarding, content: {
                onboarding()
            })
            .onAppear {
                isPresented = !didShowOnboarding
            }
    }
}

extension OnboardingModifier {
    func onDismissOnboarding() {
        didShowOnboarding = true
        onDisappear()
    }
}

public struct OnboardingContent: View {
    var views: [AnyView]
    var indexes: Range<Int>
    
    init(views: [any View]) {
        self.views = views.map { AnyView($0) }
        self.indexes = 0..<self.views.count
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.ds.brand.tertiary)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(
            Color.ds.text.background.primary.opacity(ds: .disabled)
        )
    }
    
    @State private var selection: Int = 0
    @State private var shouldFinish: Bool = false

    @Environment(\.dismiss) var dismiss
    @Environment(\.subscriptionStatus) var subscriptionStatus
    
    
    public var body: some View {
        if shouldFinish {
            switch subscriptionStatus {
            case .subscribed:
                Color.clear.onAppear { dismiss() }
            case .notSubscribed:
                NavigationStack {
                    Paywall()
                }
            }
        } else {
            VStack(spacing: .ds.spacing.xLarge) {
                steps
                button
            }
            .textStyle(ds: .largeTitle)
            .padding(ds: .medium)
        }
    }
    
    @ViewBuilder
    var steps: some View {
        TabView(selection: $selection)  {
            ForEach(indexes, id: \.self) { index in
                views[index]
                    .id(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .tint(.ds.brand.primary)
    }
    
    @ViewBuilder
    var button: some View {
        if !shouldFinish {
            Button(action: next, label: {
                Text("Continue")
            })
            .buttonStyle(.dsAction)
        }
    }
    
    func next() {
        if selection >= views.endIndex-1 {
            shouldFinish = true
        } else {
            withAnimation {
                selection += 1
            }
        }
    }
}

@resultBuilder
public enum OnboardingContentBuilder {
    public static func buildBlock(_ component: OnboardingContent) -> OnboardingContent {
        component
    }
    
    public static func buildBlock(_ components: [OnboardingPage]) -> OnboardingContent {
        OnboardingContent(views: components)
    }
    
    public static func buildBlock(_ components: OnboardingPage...) -> OnboardingContent {
        OnboardingContent(views: components)
    }
}

@resultBuilder
public enum OnboardingPageContentBuilder {
    public static func buildBlock(
        _ image: Image, _ title: String, _ subtitle: String
    ) -> OnboardingPageContent {
        OnboardingPageContent(image: image, title: title, subtitle: subtitle)
    }
}

public struct OnboardingPageContent {
    var image: Image
    var title: String
    var subtitle: String
}

public struct OnboardingPage: View {

    var content: OnboardingPageContent
    
    public init(@OnboardingPageContentBuilder _ content: () -> OnboardingPageContent) {
        self.content = content()
    }
    
    var appIconRoundedSize: CGSize {
        let size = CGSize.ds.large
        let ratio = 1/6.4
        let side = size*ratio
        return CGSize(width: side, height: side)
    }

    public var body: some View {
        VStack(alignment: .center, spacing: .ds.spacing.xLarge) {
            content.image
                .resizable()
                .scaledToFit()
                .frame(ds: .large)
                .clipShape(RoundedRectangle(cornerSize: appIconRoundedSize))
            Text(content.title)
                .textStyle(ds: .title1)
            Text(content.subtitle)
                .multilineTextAlignment(.center)
                .textStyle(ds: .body)
        }
    }
}

#Preview {
    Color.blue
        .onboarding {
            OnboardingPage {
                Image(systemName: "heart")
                "Title 1"
                "lorem ipsum dolor sit amet 1"
            }
            
            OnboardingPage {
                Image(systemName: "heart")
                "Title 2"
                "lorem ipsum dolor sit amet 2"
            }
        }
        .withSubscriptionService(
            mock: .notSubscribed
        )
}
