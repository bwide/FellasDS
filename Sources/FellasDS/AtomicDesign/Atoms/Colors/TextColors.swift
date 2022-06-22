//
//  File.swift
//  
//
//  Created by Bruno Wide on 09/03/22.
//

import Foundation
import SwiftUI

public enum DSTextColor: String, DSColor, CaseIterable {

    case primary = "Primary"
    case secondary = "Secondary"
    case tertiary = "Tertiary"
    case placeholder = "Placeholder"
    case link = "Link"

    public var color: Color {
        Color("Text\(rawValue)", bundle: Bundle.module)
    }

    public var groupedColor: Color {
        switch self {
        case .placeholder, .link: return color
        default: return Color("TextGrouped\(rawValue)", bundle: Bundle.module)
        }
    }
}

public struct FDSTextColors {
    public let background = Background()
    public let grouped = Grouped()
    
    public struct Background {
        public let primary = DSTextColor.primary.color
        public let secondary = DSTextColor.secondary.color
        public let tertiary = DSTextColor.tertiary.color
        public let placeholder = DSTextColor.placeholder.color
        public let link = DSTextColor.link.color
    }
    
    public struct Grouped {
        public let primary = DSTextColor.primary.groupedColor
        public let secondary = DSTextColor.secondary.groupedColor
        public let tertiary = DSTextColor.tertiary.groupedColor
        public let placeholder = DSTextColor.placeholder.groupedColor
        public let link = DSTextColor.link.groupedColor
    }
}
