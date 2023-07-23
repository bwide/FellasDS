//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 12/11/22.
//

import Foundation
import SwiftUI

extension ButtonStyle {
    @ViewBuilder
    func background(
        _ configuration: Configuration,
        isEnabled: Bool,
        dsColor: DSColor = DSBrandColor.primary
    ) -> some View {
        dsColor.color
            .opacity(configuration.opacity(isEnabled: isEnabled))
    }
}

extension ButtonStyle.Configuration {
    func opacity(isEnabled: Bool) -> CGFloat {
        (isPressed || !isEnabled) ? DSOpacity.disabled.rawValue : DSOpacity.opaque.rawValue
    }
}
