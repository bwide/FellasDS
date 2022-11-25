//
//  Loaders.swift
//  
//
//  Created by Bruno Fulber Wide on 24/11/22.
//

import Foundation
import SwiftUI

struct DSLoaderView: ViewModifier {
    
    @Environment(\.isLoading) var isLoading: Bool
    
    func body(content: Content) -> some View {
        if isLoading {
            content
                .overlay(Material.thin)
                .overlay { ProgressView() }
        } else {
            content
        }
    }
}

struct DSLoaderPreview: PreviewProvider {
    
    static var previews: some View {
        Color.blue
            .frame(ds: .large)
            .isLoading(true)
            .clipShape(Circle())
    }
}

public enum DSLoadingStyle {
    case `default`
    
    var loadingModifier: some ViewModifier {
        switch self {
        case .default:
            return DSLoaderView()
        }
    }
}
