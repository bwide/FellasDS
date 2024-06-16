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
import FellasAnalytics

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
        modifier(OnboardingModifier(
            onboarding,
            onDisappear: onDisappear
        ))
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
    var outro: any View
    var indexes: Range<Int>
    
    init(views: [any View], outro: any View) {
        self.views = views.map { AnyView($0) }
        self.outro = outro
        self.indexes = 0..<self.views.count
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.ds.brand.tertiary)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(
            Color.ds.text.background.primary.opacity(ds: .disabled)
        )
    }
    
    @State private var currentIndex: Int = 0
    @State private var shouldFinish: Bool = false
    @State private var shouldShowOutro: Bool = false
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.subscriptionStatus) var subscriptionStatus
    @Environment(\.analytics) var analytics
    
    public var body: some View {
        if shouldFinish {
            paywall
        } else if shouldShowOutro {
            AnyView(outro)
                .onAppear(perform: {
                    logAppear(index: views.count)
                    
                    Task { @MainActor in
                        try? await Task.sleep(for: .seconds(4))
                        next()
                    }
                })
        } else {
            ZStack {
                steps
                VStack {
                    Spacer()
                    button
                        .padding(.vertical, ds: .xxLarge)
                        .padding(.horizontal, ds: .large)
                }
            }
            .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    var paywall: some View {
        switch subscriptionStatus {
        case .subscribed:
            Color.clear.onAppear { dismiss() }
        case .notSubscribed:
            NavigationStack {
                Paywall()
            }
        }
    }
    
    @ViewBuilder
    var steps: some View {
        TabView(selection: $currentIndex)  {
            ForEach(indexes, id: \.self) { index in
                views[index]
                    .id(index)
                    .fixedSize(horizontal: false, vertical: false)
                    .onAppear(perform: {
                        logAppear(index: index)
                    })
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .tint(.ds.brand.primary)
    }
    
    @ViewBuilder
    var button: some View {
        if !shouldFinish {
            Button("Continue", action: next)
                .buttonStyle(.dsAction)
        }
    }
    
    private func next() {
        if currentIndex == views.endIndex-1 {
            shouldShowOutro = true
        } else if shouldShowOutro {
            shouldFinish = true
            shouldShowOutro = false
        }
        
        withAnimation {
            currentIndex += 1
        }
    }
    
    private func logAppear(index: Int) {
        analytics.log(event: .init(name: "onboarding_s\(index+1)"))
    }
}

@resultBuilder
public enum OnboardingContentBuilder {
    public static func buildBlock(_ component: OnboardingContent) -> OnboardingContent {
        component
    }
    
    public static func buildBlock<Intro: View, Outro: View, Option: View, Option1: View, Option2: View>(
        _ intro: Intro,
        _ components1: Option,
        _ components2: Option1,
        _ components3: Option2,
        _ outro: Outro
    ) -> OnboardingContent {
        OnboardingContent(views: [intro, components1, components2, components3], outro: outro)
    }
    
    public static func buildBlock<Intro: View, Outro: View, Option: View, Option1: View, Option2: View, Option3: View>(
        _ intro: Intro,
        _ components1: Option,
        _ components2: Option1,
        _ components3: Option2,
        _ components4: Option3,
        _ outro: Outro
    ) -> OnboardingContent {
        OnboardingContent(views: [intro, components1, components2, components3, components4], outro: outro)
    }
}


#Preview {
    Color.blue
        .onboarding(force: true) {
            OnboardingIntro {
                Image(systemName: "heart")
                "Titlte"
                "subtitle"
            }
            
            OnboardingPage {
                Image(systemName: "heart")
                
                "how would you describe your current experience with the bible?"
                
                
                Text(verbatim: "📖 i've read nothing")
                Text(verbatim: "i know a few verses")
                // ...
                // ...

            }
            
            OnboardingPage {
                Image(systemName: "heart")
                "What does reading the bible bring you?"
                
                Text(verbatim: "motivation")
                Text(verbatim: "guidance")
                // ...
                // ...
            }
            
            OnboardingPage {
                Image(systemName: "heart")
                "what do you expect from this app?"
                
                Text(verbatim: "improve my knowledge")
                Text(verbatim: "daily motivation")
                // ...
                // ...
            }
            
            OnboardingOutro {
                Image(systemName: "heart")
            }
        }
        .withSubscriptionService(
            mock: .notSubscribed
        )
}
