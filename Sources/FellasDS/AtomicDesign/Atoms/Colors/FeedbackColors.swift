//
//  File.swift
//  
//
//  Created by Bruno Wide on 09/03/22.
//

import Foundation
import SwiftUI

public enum DSFeedbackColor: String, DSColor, CaseIterable {

    case positive = "Positive"
    case warning = "Warning"
    case negative = "Negative"

    public var color: Color {
        Color("Feedback\(rawValue)", bundle: Bundle.module)
    }
}

public struct FDSFeedbackColors {
    public let positive = DSFeedbackColor.positive.color
    public let warning = DSFeedbackColor.warning.color
    public let negative = DSFeedbackColor.negative.color
}
