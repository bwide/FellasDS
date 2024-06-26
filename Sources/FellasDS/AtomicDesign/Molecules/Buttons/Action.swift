//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 21/06/22.
//

import Foundation
import SwiftUI

public struct DSActionButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label
                .textStyle(
                    ds: .title2,
                    color: .ds.text.grouped.primary
                )
                .padding(.vertical, .ds.spacing.small)
                .padding(.horizontal, .ds.spacing.medium)
            Spacer()
        }
            .background(
                background(configuration,
                           isEnabled: isEnabled)
            )
            .withLoader()
            .clipShape(RoundedRectangle(cornerRadius: .ds.cornerRadius.small))
            .frame(maxWidth: 400)
    }
}

public extension Button {
    @ViewBuilder
    func hoveringActionButton() -> some View {
        HoveringActionButton {
            self
        }
    }
}

struct HoveringActionButton<Button: View>: View {
    
    var button: () -> Button
    
    var body: some View {
        VStack {
            Spacer()
            button()
                .buttonStyle(.dsAction)
        }
        .padding(.bottom, ds: .small)
        .padding(.horizontal, ds: .medium)
    }
}

struct DSActionPreview: PreviewProvider {
    static var previews: some View {
        Group {
            VStack {
                Button {
                } label: {
                    Text(verbatim: "Text")
                }
                    .buttonStyle(.dsAction)
                    .isLoading(false)
                Button {
                } label: {
                    Text(verbatim: "Text")
                }
                    .buttonStyle(.dsAction)
                    .isLoading(true)
            }
        }
    }
}
