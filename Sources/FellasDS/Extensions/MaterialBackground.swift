//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 02/07/24.
//

import Foundation
import SwiftUI

struct MaterialBackground: ViewModifier {
    
    var padding: DSSpacing
    var cornerRadius: DSCornerRadius
    var material: Material
    
    func body(content: Content) -> some View {
        content
            .padding(ds: padding)
            .background {
                Color.ds.background.primary
                    .opacity(0.1)
                    .background(material)
                    .cornerRadius(ds: cornerRadius)
            }
    }
}

public extension View {
    func materialBackground(padding: DSSpacing, cornerRadius: DSCornerRadius = .large, material: Material = .ultraThin) -> some View {
        modifier(MaterialBackground(padding: padding, cornerRadius: cornerRadius, material: material))
    }
}
