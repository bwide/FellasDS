//
//  File.swift
//  
//
//  Created by Bruno Wide on 25/01/22.
//

import Foundation
import SwiftUI

struct DSTextStyle: ViewModifier {

    var style: DSTypographyStyle

    func body(content: Content) -> some View {
        content
            .font(style.font)
            .foregroundColor(style.color)
    }
}


public extension View {
    @ViewBuilder
    func style(_ style: DSTypographyStyle, defaultPosition: Bool = true) -> some View {
        if defaultPosition {
            modifier(DSTextStyle(style: style))
                .defaultPosition(for: style)
        } else {
            modifier(DSTextStyle(style: style))
        }
    }
}

private extension View {
    @ViewBuilder
    func defaultPosition(for style: DSTypographyStyle) -> some View {
        switch style {
        case .largeTitle:
            HStack { self.padding(style.insets); Spacer() }
        case .title1:
            self.padding(style.insets)
        case .title2:
            self.padding(style.insets)
        case .title3:
            self.padding(style.insets)
        case .headline:
            self.padding(style.insets)
        case .subhead:
            self.padding(style.insets)
        case .body:
            self.padding(style.insets)
        case .callout:
            self.padding(style.insets)
        case .footnote:
            self.padding(style.insets)
        case .caption1:
            self.padding(style.insets)
        case .caption2:
            self.padding(style.insets)
        }
    }
}
