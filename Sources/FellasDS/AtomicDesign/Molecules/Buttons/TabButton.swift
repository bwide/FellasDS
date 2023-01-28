//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 11/11/22.
//

import Foundation
import SwiftUI

public struct DSToolItemStyle: ButtonStyle {
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    public func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: .ds.spacing.xxSmall) {
            configuration.label
        }
        .padding(ds: .xxSmall)
        .textStyle(ds: .callout)
        .opacity(configuration.opacity(isEnabled: isEnabled))
    }
}

struct DSTabButtonStylePreview: PreviewProvider {
    static var previews: some View {
        Group {
            Button(action: {
                
            }, label: {
                Image(systemName: "signature")
                Text(verbatim: "signature")
            })
            .buttonStyle(.dsToolItem)
        }
    }
}
