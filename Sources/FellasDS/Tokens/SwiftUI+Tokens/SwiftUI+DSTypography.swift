//
//  File.swift
//  
//
//  Created by Bruno Wide on 25/01/22.
//

import Foundation
import SwiftUI

extension Text {
    func style(_ style: DSTypographyStyle) -> some View {
        modifier(DSTextStyle(style: style))
    }
}


struct DSTextStyle: ViewModifier {

    var style: DSTypographyStyle

    func body(content: Content) -> some View {
        content
            .font(style.font)
            .foregroundColor(style.color)
    }
}
