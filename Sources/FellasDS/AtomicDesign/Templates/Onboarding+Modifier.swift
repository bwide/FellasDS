//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 22/10/23.
//

import Foundation
import SwiftUI
import SwiftResources

public extension View {
    func forceOnboarding(_ value: Bool) -> some View {
        task {
            UserDefaults.standard
                .setValue(value, forKey: "didShowOnboarding")
        }
    }
    
    func onboarding(
        force isOnboarding: Bool? = false,
        @OnboardingContentBuilder _ onboarding: @escaping () -> OnboardingContent
    ) -> some View {
        modifier(OnboardingModifier(onboarding))
            .task {
                guard let isOnboarding else { return }
                UserDefaults.standard
                    .setValue(isOnboarding, forKey: "didShowOnboarding")
            }
    }
}

struct OnboardingModifier: ViewModifier {
    
    var onboarding: () -> OnboardingContent
    
    init(@OnboardingContentBuilder _ onboarding: @escaping () -> OnboardingContent) {
        self.onboarding = onboarding
    }
    
    @State private var isPresented: Bool = false
    @AppStorage("didShowOnboarding") private var didShowOnboarding: Bool = false
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented, onDismiss: onDismissOnboarding, content: {
                onboarding()
            })
            .task {
                isPresented = !didShowOnboarding
            }
    }
}

extension OnboardingModifier {
    func onDismissOnboarding() {
        didShowOnboarding = true
    }
}

public struct OnboardingContent: View {
    var views: [AnyView]
    var indexes: Range<Int>
    
    init(views: [any View]) {
        self.views = views.map { AnyView($0) }
        self.indexes = 0..<self.views.count
    }
    
    @State private var selection: Int = 0
    @Environment(\.dismiss) var dismiss
    @Environment(\.subscriptionStatus) var subscriptionStatus
    
    private var shouldFinish: Bool {
        selection >= views.endIndex
    }
    
    public var body: some View {
        if shouldFinish {
            switch subscriptionStatus {
            case .subscribed:
                Color.clear
                    .onAppear { dismiss() }
            case .notSubscribed:
                Paywall()
            }
        } else {
            VStack(spacing: .ds.spacing.xxLarge) {
                steps
                button
            }
            .textStyle(ds: .largeTitle)
            .padding(ds: .medium)
        }
    }
    
    @ViewBuilder
    var steps: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: .ds.spacing.large) {
                    ForEach(indexes, id: \.self) { index in
                        onboardingItem(at: index, with: proxy)
                    }
                }
                .padding(.bottom, 800)
            }
        }
    }
    
    @ViewBuilder
    func onboardingItem(at index: Int, with proxy: ScrollViewProxy) -> some View {
        if selection >= index {
            HStack {
                views[index]
                Spacer()
            }
            .id(index)
            .transition(.opacity)
            .onAppear {
                proxy.scrollTo(index, anchor: .bottom)
            }
        }
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
        withAnimation {
            selection += 1
        }
    }
}

@resultBuilder
public enum OnboardingContentBuilder {
    public static func buildBlock(_ components: (any View)...) -> OnboardingContent {
        OnboardingContent(views: components)
    }
}

#Preview {
    Color.blue
        .onboarding {
            Text("lorem ipsum dolor sit amet")
            Text("lorem ipsum dolor sit amet 2")
            Text("lorem ipsum dolor sit amet 3")
        }
        .withSubscriptionService(
            mock: .notSubscribed
        )
}
