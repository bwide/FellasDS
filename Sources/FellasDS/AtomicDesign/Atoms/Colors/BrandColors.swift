//
//  File.swift
//  
//
//  Created by Bruno Wide on 09/03/22.
//

import Foundation
import SwiftUI

public enum DSBrandColor: String, DSColor, CaseIterable {

    case primary = "Primary"
    case secondary = "Secondary"
    case tertiary = "Tertiary"

    public var color: Color {
        #if DEBUG
        Color("Brand\(rawValue)", bundle: Bundle.main)
        #else
        Color("Brand\(rawValue)", bundle: Bundle.main)
        #endif
    }
}

public struct DSBrandColors {
    public let primary = DSBrandColor.primary.color
    public let secondary = DSBrandColor.secondary.color
    public let tertiary = DSBrandColor.tertiary.color
}

