//
//  File.swift
//  
//
//  Created by Bruno Wide on 09/03/22.
//

import Foundation
import SwiftUI
import UIKit

public enum DSTextColor: String, DSColor, CaseIterable {
    case primary
    case secondary
    case tertiary
    case placeholder
    case link

    public var color: Color {
        switch self {
        case .primary: return Color(UIColor.label)
        case .secondary: return Color(UIColor.secondaryLabel)
        case .tertiary: return Color(UIColor.tertiaryLabel)
        case .placeholder: return Color(UIColor.placeholderText)
        case .link: return Color(UIColor.link)
        }
    }
}

public struct FDSTextColors {
    public let primary = DSTextColor.primary.color
    public let secondary = DSTextColor.secondary.color
    public let tertiary = DSTextColor.tertiary.color
    public let placeholder = DSTextColor.placeholder.color
    public let link = DSTextColor.link.color
}
