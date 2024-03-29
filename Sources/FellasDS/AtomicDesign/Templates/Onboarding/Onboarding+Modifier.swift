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
    
    public var body: some View {
        if shouldFinish {
            paywall
        } else if shouldShowOutro {
            AnyView(outro)
                .onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
                        print("execute")
                        next()
                    })
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
            .textStyle(ds: .largeTitle)
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
    
    func next() {
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
}

@resultBuilder
public enum OnboardingContentBuilder {
    public static func buildBlock(_ component: OnboardingContent) -> OnboardingContent {
        component
    }
    
    public static func buildBlock<Intro: View, Outro: View, Option: View, Icon: View>(
        _ intro: Intro,
        _ outro: Outro,
        _ components: OnboardingPage<Icon, Option>...
    ) -> OnboardingContent {
        OnboardingContent(views: [intro]+components, outro: outro)
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
            
            OnboardingOutro {
                Image(systemName: "heart")
            }
            
            OnboardingPage {
                Image(systemName: "heart")
                
                "how would you describe your current experience with the bible?"
                
                
                Label("📖 i've read nothing", systemImage: "")
                Label("i know a few verses", systemImage: "heart")
                // ...
                // ...

            }
            
            OnboardingPage {
                Image(systemName: "heart")
                "What does reading the bible bring you?"
                
                Label("motivation", systemImage: "heart")
                Label("guidance", systemImage: "heart")
                // ...
                // ...
            }
            
            OnboardingPage {
                Image(systemName: "heart")
                "what do you expect from this app?"
                
                Label("improve my knowledge", systemImage: "heart")
                Label("daily motivation", systemImage: "heart")
                // ...
                // ...
            }
        }
        .withSubscriptionService(
            mock: .notSubscribed
        )
}
