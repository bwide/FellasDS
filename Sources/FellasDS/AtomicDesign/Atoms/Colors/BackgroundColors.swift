//
//  File.swift
//  
//
//  Created by Bruno Wide on 09/03/22.
//

import Foundation
import SwiftUI

public protocol DSColor {
    var rawValue: String { get }
    var color: Color { get }
}

public enum DSBackgroundColor: String, DSColor, CaseIterable {

    case primary = "Primary"
    case secondary = "Secondary"
    case tertiary = "Tertiary"

    public var color: Color {
        Color("Background\(rawValue)", bundle: Bundle.module)
    }
}

public struct DSBackgroundColors {
    public let primary = DSBackgroundColor.primary.color
    public let secondary = DSBackgroundColor.secondary.color
    public let tertiary = DSBackgroundColor.tertiary.color
}
