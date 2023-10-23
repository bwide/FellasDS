//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 23/07/23.
//

import Foundation
import SwiftUI

public struct DSToggleStyleBackground: ToggleStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(ds: .xxSmall)
            .background {
                if configuration.isOn {
                    Color.ds.brand.secondary
                        .opacity(ds: .disabled)
                        .cornerRadius(ds: .small)
                } else {
                    Color.clear
                }
            }
            .onTapGesture {
                configuration.isOn.toggle()
            }
    }
}

public extension ToggleStyle where Self == DSToggleStyleBackground {
    static var dsBackground: DSToggleStyleBackground { DSToggleStyleBackground() }
}

