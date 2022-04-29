//
//  File.swift
//  
//
//  Created by Bruno Wide on 12/03/22.
//

import Foundation
import SwiftUI

extension DSTypographyStyle {
    var insets: EdgeInsets {
        switch self {
        case .largeTitle: return EdgeInsets(top: .none, leading: .none, bottom: .none, trailing: .none)
        case .title1: return EdgeInsets(top: .none, leading: .none, bottom: .none, trailing: .none)
        case .title2: return EdgeInsets(top: .none, leading: .none, bottom: .none, trailing: .none)
        case .title3: return EdgeInsets(top: .none, leading: .none, bottom: .none, trailing: .none)
        case .headline: return EdgeInsets(top: .none, leading: .none, bottom: .none, trailing: .none)
        case .subhead: return EdgeInsets(top: .none, leading: .none, bottom: .none, trailing: .none)
        case .body: return EdgeInsets(top: .none, leading: .none, bottom: .none, trailing: .none)
        case .callout: return EdgeInsets(top: .none, leading: .none, bottom: .none, trailing: .none)
        case .footnote: return EdgeInsets(top: .none, leading: .none, bottom: .none, trailing: .none)
        case .caption1: return EdgeInsets(top: .none, leading: .none, bottom: .none, trailing: .none)
        case .caption2: return EdgeInsets(top: .none, leading: .none, bottom: .none, trailing: .none)
        }
    }
}

public extension EdgeInsets {
    init(top: DSSpacing, leading: DSSpacing, bottom: DSSpacing, trailing: DSSpacing) {
        self.init(top: top.rawValue, leading: leading.rawValue, bottom: bottom.rawValue, trailing: trailing.rawValue)
    }
}
