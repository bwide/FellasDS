//
//  File.swift
//  
//
//  Created by Bruno Wide on 09/03/22.
//

import Foundation
import SwiftUI
import UIKit

protocol DSColor {
    var rawValue: String { get }
    var color: Color { get }
}

public enum DSBackgroundColor: String, DSColor, CaseIterable {
    case primary
    case secondary
    case tertiary

    var color: Color {
        switch self {
        case .primary: return Color(UIColor.systemBackground)
        case .secondary: return Color(UIColor.secondarySystemBackground)
        case .tertiary: return Color(UIColor.tertiarySystemBackground)
        }
    }
}

public struct DSBackgroundColors {
    public let primary = DSBackgroundColor.primary.color
    public let secondary = DSBackgroundColor.secondary.color
    public let tertiary = DSBackgroundColor.tertiary.color
}
