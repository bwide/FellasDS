//
//  File.swift
//  
//
//  Created by Bruno Wide on 14/03/22.
//

import Foundation
import SwiftUI

public struct DSPillButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .textStyle(ds: .headline, color: .white)
            .padding(.vertical, .ds.spacing.xxSmall)
            .padding(.horizontal, .ds.spacing.small)
            .frame(minWidth: 67)
            .background(
                background(configuration,
                           isEnabled: isEnabled,
                           dsColor: DSBrandColor.secondary)
            )
            .withLoader()
            .clipShape(
                RoundedRectangle(cornerRadius: .ds.cornerRadius.medium)
            )
    }
}

public struct DSRoundButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .textStyle(ds: .headline, color: .white)
            .padding(.vertical, .ds.spacing.xxSmall)
            .padding(.horizontal, .ds.spacing.xxSmall)
            .background(
                background(configuration,
                           isEnabled: isEnabled,
                           dsColor: DSBrandColor.secondary)
            )
            .withLoader()
            .clipShape(Circle())
    }
}

struct PillPreview: PreviewProvider {
    static var previews: some View {
        Group {
            HStack {
                Button {
                } label: {
                    Text(verbatim: "Text")
                }                
                    .buttonStyle(.dsPill)
                Button(action: {}) {
                    Image(systemName: "plus")
                }
                    .buttonStyle(.dsRound) //TODO: remove title from here
            }
        }
    }
}

