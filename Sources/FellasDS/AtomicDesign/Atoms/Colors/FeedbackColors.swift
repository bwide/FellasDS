//
//  File.swift
//  
//
//  Created by Bruno Wide on 09/03/22.
//

import Foundation
import SwiftUI

public enum DSFeedbackColor: String, DSColor, CaseIterable {

    case success = "Success"
    case warning = "Warning"
    case error = "Error"

    public var color: Color {
        Color("Feedback\(rawValue)", bundle: Bundle.module)
    }
}

public struct FDSFeedbackColors {
    public let success = DSFeedbackColor.success.color
    public let warning = DSFeedbackColor.warning.color
    public let error = DSFeedbackColor.error.color
}
