//
//  File.swift
//  
//
//  Created by Bruno Wide on 09/03/22.
//

import Foundation
import SwiftUI

var isPreview: Bool {
    ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}

public enum DSBrandColor: String, DSColor, CaseIterable {

    case primary = "Primary"
    case secondary = "Secondary"
    case tertiary = "Tertiary"

    public var color: Color {
        Color("Brand\(rawValue)", bundle: Bundle.main)
    }
}

public struct DSBrandColors {
    public let primary = DSBrandColor.primary.color
    public let secondary = DSBrandColor.secondary.color
    public let tertiary = DSBrandColor.tertiary.color
}

