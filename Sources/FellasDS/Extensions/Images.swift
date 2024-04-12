//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 19/11/23.
//

import Foundation
import SwiftUI

public extension Image {
    static var appIcon: some View {
        GeometryReader { proxy in
            Image(uiImage: UIImage(named: "AppIcon", in: .main, with: .none) ?? UIImage())
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: proxy.size.width*0.15625))
        }
    }
    
    static func appIcon(_ assetName: String) -> some View {
        GeometryReader { proxy in
            Image(uiImage: UIImage(named: assetName, in: .main, with: .none) ?? UIImage())
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: proxy.size.width*0.15625))
        }
    }
}

#Preview {
    ZStack {
        Color.blue
        Image.appIcon
            .frame(ds: .xLarge)
    }
}
