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
    func background(
        _ configuration: Configuration,
        shape: some Shape = Rectangle(),
        dsColor: DSColor = DSBrandColor.primary
    ) -> some View {
        shape
            .fill(
                dsColor.color
                    .opacity(ds: configuration.isPressed ? .buttonPressed : .opaque)
            )
            .cornerRadius(ds: .medium)
    }
}

struct DSActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label
                .textStyle(.title2, color: .white)
                .padding(.vertical, .ds.spacing.medium)
                .padding(.horizontal, .ds.spacing.medium)
            Spacer()
        }
            .background(
                background(configuration,
                           shape: RoundedRectangle(cornerRadius: .ds.cornerRadius.small))
            )
    }
}

struct DSActionPreview: PreviewProvider {
    static var previews: some View {
        Group {
            Button("Text", action: {})
                .style(.action)
        }
    }
}

