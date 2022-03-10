//
//  File.swift
//  
//
//  Created by Bruno Wide on 09/03/22.
//

import Foundation
import SwiftUI
import UIKit

public enum DSBrandColor: String, DSColor, CaseIterable {
    case primary
    case secondary
    case tertiary

    public var color: Color {
        switch self {
        case .primary: return Color.accentColor
        case .secondary: return Color(UIColor.systemPurple)
        case .tertiary: return Color(UIColor.systemBlue)
        }
    }
}

public struct DSBrandColors {
    public let primary = DSBrandColor.primary.color
    public let secondary = DSBrandColor.secondary.color
    public let tertiary = DSBrandColor.tertiary.color
}

