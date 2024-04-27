//
//  File.swift
//
//
//  Created by Bruno Fulber Wide on 26/07/22.
//

import Foundation
import SwiftUI
import Combine

public struct VerticalPickerStyle: DSPickerStyle {
    
    var grouped: Bool
    
    public func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: .ds.spacing.small) {
            ForEach(configuration.views) { view in
                DSRowPickerItem {
                    view.label
                }
                .withTag(view.id)
                .backgroundStyle(grouped ? .grouped : .background)
            }
        }
    }
}
