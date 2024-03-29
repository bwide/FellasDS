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
    public static func buildBlock<Icon: View, Option: View>(
        _ image: Icon, _ title: String, _ options: Option...
    ) -> OnboardingPageContent<Icon, Option> {
        OnboardingPageContent(image: image, title: title, options: options)
    }
}

public struct OnboardingPageContent<Image: View, Option: View> {
    var image: Image
    var title: String
    var options: [Option]
}

// MARK: - OnboardingPage

public struct OnboardingPage<Icon: View, Option: View>: View {

    var content: OnboardingPageContent<Icon, Option>
    var indexes: [Int] = []
    
    public init(@OnboardingPageContentBuilder _ content: () -> OnboardingPageContent<Icon, Option>) {
        self.content = content()
        self.indexes = Array(0..<self.content.options.count)
    }

    public var body: some View {
        VStack {
            Spacer()
            content.image
            ZStack(alignment: .leading) {
                Color.ds.brand.primary
                    .opacity(ds: .disabled)
                    .roundedCorners(.medium, corners: [.topLeft, .topRight])
                VStack(spacing: .ds.spacing.large) {
                    title
                    picker
                    Spacer()
                }
                .padding(.horizontal, ds: .large)
            }
            .zIndex(-1)
        }
        .ignoresSafeArea()
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
        .padding(.bottom, ds: .xxxLarge)
        .dsPickerStyle(.vertical)
    }
}

public extension View {
    func appIconBorders() -> some View {
        modifier(AppIconBorders())
    }
}

struct AppIconBorders: ViewModifier {
    
    @State private var size: CGSize = .zero
    
    private func appIconRoundedCorners(for size: Double) -> CGSize {
        let ratio = 1/6.4
        let side = size*ratio
        return CGSize(width: side, height: side)
    }
    
    func body(content: Content) -> some View {
        content
            .readSize($size)
            .clipShape(RoundedRectangle(cornerSize: appIconRoundedCorners(for: max(size.width, size.height))))
    }
}

#Preview {
    OnboardingPage {
        Image(systemName: "heart")
        "What should the title be?"
        
        Label(
            title: { Text("Label with long title testing two lines of text here") },
            icon: { Image(systemName: "42.circle") }
        )
        Label(
            title: { Text("Label with long title testing two lines of text here") },
            icon: { Image(systemName: "42.circle") }
        )
        Label(
            title: { Text("Label") },
            icon: { Image(systemName: "42.circle") }
        )
        Label(
            title: { Text("Label") },
            icon: { Image(systemName: "42.circle") }
        )
    }
}
