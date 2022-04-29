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
        case .largeTitle: return .largeTitle.weight(.bold)
        case .title1: return .title.weight(.bold)
        case .title2: return .title2.weight(.bold)
        case .title3: return .title3.weight(.medium)
        case .headline: return .headline.weight(.bold)
        case .subhead: return .subheadline.weight(.semibold)
        case .body: return .body.weight(.medium)
        case .callout: return .callout.weight(.medium)
        case .footnote: return .footnote.weight(.medium)
        case .caption1: return .caption.weight(.medium)
        case .caption2: return .caption2.weight(.semibold)
        }
    }

    var color: Color {
        switch self {
        case .largeTitle: return DSTextColor.primary.color
        case .title1: return DSTextColor.primary.color
        case .title2: return DSTextColor.primary.color
        case .title3: return DSTextColor.primary.color
        case .headline: return .white
        case .subhead: return DSTextColor.secondary.color
        case .body: return DSTextColor.primary.color
        case .callout: return DSTextColor.secondary.color
        case .footnote: return DSTextColor.tertiary.color
        case .caption1: return DSTextColor.secondary.color
        case .caption2: return DSTextColor.tertiary.color
        }
    }
}

struct FontsStylesPreview: PreviewProvider {
    static var previews: some View {
        Group {
            VStack(alignment: .leading, spacing: .ds.spacing.large) {
                ForEach(DSTypographyStyle.allCases, id: \.self) { style in
                    Text(style.rawValue)
                        .style(style)
                }
            }
            .padding(.leading, .ds.spacing.medium)
        }
        .preferredColorScheme(.light)
    }
}
