//
//  File.swift
//  
//
//  Created by Bruno Wide on 20/02/22.
//

import Foundation
import SwiftUI

public struct Background: View {
    
    public var style: DSBackgroundColor = .primary
    
    public init(_ style: DSBackgroundColor = .primary) {
        self.style = style
    }
    
    public var body: some View {
        style.color.ignoresSafeArea()
    }
}

public extension View {
    @ViewBuilder
    func background(style: DSBackgroundColor) -> some View {
        self.background(style.color)
    }

    @ViewBuilder
    func foregroundColor(_ style: DSBrandColor) -> some View {
        self.foregroundColor(style.color)
    }
}

public extension Color {
    static var ds = FDSColors()
    
    @inlinable func opacity(ds opacity: DSOpacity) -> Color {
        self.opacity(opacity.rawValue)
    }
}

public struct FDSColors {
    public var background = DSBackgroundColors()
    public var text = FDSTextColors()
    public var feedback = FDSFeedbackColors()
    public var brand = DSBrandColors()
}
