//
//  File.swift
//  
//
//  Created by Bruno Wide on 20/02/22.
//

import Foundation
import SwiftUI

public extension Color {
    static var fds = FDSColors()
}

public struct FDSColors {
    public var background = FDSBackgroundColors()
    public var text = FDSTextColors()
    public var feedback = FDSFeedbackColors()
    public var brand = FDSBrandColors()
}

public struct FDSBackgroundColors {
    public let primary = Color(UIColor.systemBackground)
    public let secondary = Color(UIColor.secondarySystemBackground)
    public let tertiary = Color(UIColor.tertiarySystemBackground)
}

public struct FDSTextColors {
    public let primary = Color(UIColor.label)
    public let secondary = Color(UIColor.secondaryLabel)
    public let tertiary = Color(UIColor.tertiaryLabel)
    public let placeholder = Color(UIColor.placeholderText)
    public let link = Color(UIColor.link)
}

public struct FDSFeedbackColors {
    public let success = Color(UIColor.systemGreen)
    public let warning = Color(UIColor.systemYellow)
    public let danger = Color(UIColor.systemRed)
}

public struct FDSBrandColors {
    public let primary = Color.accentColor
    public let secondary = Color(UIColor.systemPurple)
    public let tertiary = Color(UIColor.systemBlue)
}
