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
    func background<BackgroundShape: Shape>(
        _ configuration: Configuration,
        isEnabled: Bool,
        shape: BackgroundShape, // TODO: some Shape
        dsColor: DSColor = DSBrandColor.primary
    ) -> some View {
        shape
            .fill(
                dsColor.color
                    .opacity(configuration.opacity(isEnabled: isEnabled))
            )
            .cornerRadius(ds: .medium)
    }
}

extension ButtonStyle.Configuration {
    func opacity(isEnabled: Bool) -> CGFloat {
        (isPressed || !isEnabled) ? DSOpacity.disabled.rawValue : DSOpacity.opaque.rawValue
    }
}
