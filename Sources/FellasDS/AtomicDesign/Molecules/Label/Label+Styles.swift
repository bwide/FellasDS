//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 22/07/23.
//

import Foundation
import SwiftUI

public struct DSVerticalLabelStyle: LabelStyle {
    public func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: .ds.spacing.xxxSmall, content: {
            configuration.icon
            configuration.title
        })
        .padding(ds: .xxxSmall)
    }
}

public extension LabelStyle where Self == DSVerticalLabelStyle {
    static var dsVertical: DSVerticalLabelStyle { DSVerticalLabelStyle() }
}
