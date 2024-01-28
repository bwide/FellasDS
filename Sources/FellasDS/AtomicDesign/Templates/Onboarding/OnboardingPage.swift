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
    public static func buildBlock(
        _ image: Image, _ title: String, _ options: Label<Text, Image>...
    ) -> OnboardingPageContent {
        OnboardingPageContent(image: image, title: title, options: options)
    }
}

public struct OnboardingPageContent {
    var image: Image
    var title: String
    var options: [Label<Text, Image>]
}

// MARK: - OnboardingPage

public struct OnboardingPage: View {

    var content: OnboardingPageContent
    var indexes: [Int] = []
    
    public init(@OnboardingPageContentBuilder _ content: () -> OnboardingPageContent) {
        self.content = content()
        self.indexes = Array(0..<self.content.options.count)
    }
    
    var appIconRoundedSize: CGSize {
        let size = CGSize.ds.large
        let ratio = 1/6.4
        let side = size*ratio
        return CGSize(width: side, height: side)
    }

    public var body: some View {
        VStack(spacing: .zero) {
            Spacer()
            header
            Spacer()
            
            DSPicker {
                ForEach(indexes, id: \.self) { item in
                    content.options[item]
                }
            }
            .frame(maxHeight: .infinity)
            .textStyle(ds: .title3)
            .padding(.bottom, ds: .xxxLarge)
            .dsPickerStyle(.vertical)
            
            Spacer()
        }
    }
    
    var header: some View {
        VStack(spacing: .ds.spacing.xLarge) {
            content.image
                .resizable()
                .scaledToFit()
                .frame(ds: .large)
                .clipShape(RoundedRectangle(cornerSize: appIconRoundedSize))
            
            Text(content.title)
                .multilineTextAlignment(.leading)
                .textStyle(ds: .title1)
        }
    }
}
