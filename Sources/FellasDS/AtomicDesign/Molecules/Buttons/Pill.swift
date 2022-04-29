//
//  File.swift
//  
//
//  Created by Bruno Wide on 14/03/22.
//

import Foundation
import SwiftUI

struct DSPillButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(DSTypographyStyle.headline.font)
            .foregroundColor(DSTypographyStyle.headline.color)
            .padding(.vertical, .ds.spacing.xxSmall)
            .padding(.horizontal, .ds.spacing.small)
            .background(background)
    }

    var background: some View {
        Rectangle()
            .fill(Color.ds.brand.primary)
            .cornerRadius(.medium)
    }
}

struct DSRoundButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(DSTypographyStyle.headline.font)
            .foregroundColor(DSTypographyStyle.headline.color)
            .padding(.vertical, .ds.spacing.xxSmall)
            .padding(.horizontal, .ds.spacing.xxSmall)
            .background(
                Circle()
                    .fill(Color.ds.brand.primary)
            )
    }
}

struct PillPreview: PreviewProvider {
    static var previews: some View {
        Group {
            HStack {
                Button("Text", action: {})
                    .style(.pill)
                Button(systemIcon: "plus", action: {})
                    .style(.round)
            }
        }
    }
}
