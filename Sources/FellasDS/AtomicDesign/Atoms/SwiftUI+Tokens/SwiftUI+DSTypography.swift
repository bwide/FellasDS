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
    @State var color: Color?

    func body(content: Content) -> some View {
        content
            .font(style.font)
            .foregroundColor(color ?? style.defaultColor)
            .padding(style.insets)
    }
}


public extension View {
    @ViewBuilder
    func textStyle(ds style: DSTypographyStyle, color: Color? = nil) -> some View {
        modifier(DSTextStyle(style: style, color: color ?? style.defaultColor))
    }
}
