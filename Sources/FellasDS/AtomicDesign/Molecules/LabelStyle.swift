//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 22/07/23.
//

import Foundation
import SwiftUI

public struct DSLabelStyleVertical: LabelStyle {
    public func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: .ds.spacing.xxSmall, content: {
            configuration.icon
            configuration.title
        })
    }
}

public extension LabelStyle where Self == DSLabelStyleVertical {
    static var dsVertical: DSLabelStyleVertical { DSLabelStyleVertical() }
}

