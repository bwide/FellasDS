//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 02/07/24.
//

import Foundation
import SwiftUI

public struct DSMaterialStyle: ButtonStyle {
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .labelStyle(.dsVertical)
            .textStyle(ds: .callout)
            .materialBackground(padding: .small, cornerRadius: .xSmall)
            .opacity(configuration.opacity(isEnabled: isEnabled))
    }
}



#Preview {
    ZStack {
        Color.blue
        Button(action: { }, label: {
            Label("Dice", systemImage: "dice")
        })
        .buttonStyle(.dsMaterial)
    }
}
