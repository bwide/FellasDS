//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 01/05/24.
//

import Foundation
import SwiftUI

public struct EmptyState: View {
    
    public var image: ImageResource
    public var text: String
    
    public init(image: ImageResource, text: String) {
        self.image = image
        self.text = text
    }
    
    public var body: some View {
        ZStack {
            Image(.backgroundEffect)
                .resizable()
                .scaledToFill()
                .tint(.ds.text.background.primary)
            VStack {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .padding(ds: .large)
                Text(text)
            }
        }
        .textStyle(ds: .title1, color: .ds.text.background.secondary)
    }
}
