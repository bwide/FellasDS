//
//  File.swift
//  
//
//  Created by Bruno Wide on 20/02/22.
//

import Foundation
import SwiftUI

public extension View {
    func background(_ style: DSBackgroundColor) -> some View {
        self.background(style.color)
    }

    func foregroundColor(_ style: DSBrandColor) -> some View {
        self.foregroundColor(style.color)
    }
}

public extension Color {
    static var fds = FDSColors()
}

public struct FDSColors {
    public var background = DSBackgroundColors()
    public var text = FDSTextColors()
    public var feedback = FDSFeedbackColors()
    public var brand = DSBrandColors()
}
