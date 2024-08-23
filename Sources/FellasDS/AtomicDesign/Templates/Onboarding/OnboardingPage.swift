//
//  OnboardingPage.swift
//  
//
//  Created by Bruno Fulber Wide on 14/01/24.
//

import Foundation
import SwiftUI

@resultBuilder
public enum OnboardingPageContentBuilder {
    public static func buildBlock<Option: View>(
        _ image: any View, _ title: String, _ options: Option...
    ) -> OnboardingPageContent<Option> {
        OnboardingPageContent(image: AnyView(image), title: title, options: options)
    }
}

public struct OnboardingPageContent<Option: View> {
    var image: AnyView
    var title: String
    var options: [Option]
}

// MARK: - OnboardingPage

public struct OnboardingPage<Option: View>: View {

    var content: OnboardingPageContent<Option>
    var indexes: [Int] = []
    
    public init(@OnboardingPageContentBuilder _ content: () -> OnboardingPageContent<Option>) {
        self.content = content()
        self.indexes = Array(0..<self.content.options.count)
    }

    public var body: some View {
        VStack(spacing: .ds.spacing.large) {
            Spacer()
            title
            picker
        }
        .padding(.horizontal, ds: .large)
        .padding(.bottom, ds: .xxxLarge)
        .padding(.bottom, ds: .xLarge)
        .background {
            GeometryReader { geo in
                VStack(spacing: .zero) {
                    content.image
                        .frame(
                            maxWidth: geo.size.width,
                            maxHeight: 500
                        )
                        .overlay {
                            LinearGradient(
                                colors: [.clear, .ds.background.primary],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        }
                    
                    Color.ds.background.primary
                }
                .ignoresSafeArea()
            }
        }
    }
    
    var title: some View {
        HStack {
            Text(content.title)
                .textStyle(ds: .title1)
                .padding(.top, ds: .xxLarge)
            Spacer()
        }
    }
    
    @ViewBuilder
    var picker: some View {
        DSPicker {
            ForEach(indexes, id: \.self) { item in
                content.options[item]
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .textStyle(ds: .subhead)
        .dsPickerStyle(.verticalGrouped)
    }
}

#Preview {
    OnboardingPage {
        Image(.paywallBg)
            .resizable()
        
        "What should a long title with two lines be?"
        
        Label(
            title: { Text(verbatim: "Label with long title testing two lines of text here") },
            icon: { Image(systemName: "42.circle") }
        )
        Label(
            title: { Text(verbatim: "Label with long title testing two lines of text here") },
            icon: { Image(systemName: "42.circle") }
        )
        Label(
            title: { Text(verbatim: "Label") },
            icon: { Image(systemName: "42.circle") }
        )
        Label(
            title: { Text(verbatim: "Label") },
            icon: { Image(systemName: "42.circle") }
        )
    }
}
