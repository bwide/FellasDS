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
            .padding(style.insets)
    }
}


public extension Text {
    @ViewBuilder
    func style(_ style: DSTypographyStyle) -> some View {
        modifier(DSTextStyle(style: style))
    }
}
