//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 21/06/22.
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
                    .opacity(ds:
                                (configuration.isPressed || !isEnabled) ? .disabled : .opaque
                            )
            )
            .cornerRadius(ds: .medium)
    }
}

public struct DSActionButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label
                .textStyle(ds: .title2, color: .white)
                .padding(.vertical, .ds.spacing.medium)
                .padding(.horizontal, .ds.spacing.medium)
            Spacer()
        }
            .background(
                background(configuration,
                           isEnabled: isEnabled,
                           shape: RoundedRectangle(cornerRadius: .ds.cornerRadius.small))
            )
    }
}

struct DSActionPreview: PreviewProvider {
    static var previews: some View {
        Group {
            Button("Text", action: {})
                .buttonStyle(.dsAction)
        }
    }
}

