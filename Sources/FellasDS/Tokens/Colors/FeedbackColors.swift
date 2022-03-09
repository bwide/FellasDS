//
//  File.swift
//  
//
//  Created by Bruno Wide on 09/03/22.
//

import Foundation
import SwiftUI
import UIKit

public enum DSFeedbackColor: String, DSColor, CaseIterable {
    case success
    case warning
    case danger

    var color: Color {
        switch self {
        case .success: return Color(UIColor.systemGreen)
        case .warning: return Color(UIColor.systemYellow)
        case .danger: return Color(UIColor.systemRed)
        }
    }
}

public struct FDSFeedbackColors {
    public let success = DSFeedbackColor.success.color
    public let warning = DSFeedbackColor.warning.color
    public let danger = DSFeedbackColor.danger.color
}
