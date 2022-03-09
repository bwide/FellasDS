//
//  DSTypographyStyle.swift
//  
//
//  Created by Bruno Wide on 20/02/22.
//

import Foundation
import SwiftUI

public enum DSTypographyStyle: String, CaseIterable {

    case largeTitle

    case title1
    case title2
    case title3

    case headline
    case subhead

    case body

    case callout
    case footnote

    case caption1
    case caption2

    var font: Font {
        switch self {
        case .largeTitle: return .largeTitle
        case .title1: return .title
        case .title2: return .title2
        case .title3: return .title3
        case .headline: return .headline
        case .subhead: return .subheadline
        case .body: return .body
        case .callout: return .callout
        case .footnote: return .footnote
        case .caption1: return .caption
        case .caption2: return .caption2
        }
    }

    var color: Color {
        switch self {
        case .largeTitle: return DSTextColor.primary.color
        case .title1: return DSTextColor.primary.color
        case .title2: return DSTextColor.primary.color
        case .title3: return DSTextColor.primary.color
        case .headline: return DSTextColor.secondary.color
        case .subhead: return DSTextColor.secondary.color
        case .body: return DSTextColor.primary.color
        case .callout: return DSTextColor.tertiary.color
        case .footnote: return DSTextColor.tertiary.color
        case .caption1: return DSTextColor.tertiary.color
        case .caption2: return DSTextColor.tertiary.color
        }
    }
}
