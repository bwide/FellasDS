//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 04/04/23.
//

import Foundation
import SwiftUI

public struct DSAsyncImage: View {
    
    var url: URL?
    
    public init(url: URL? = nil) {
        self.url = url
    }
    
    public var body: some View {
        AsyncImage(url: url) { phase in
            DSAsyncImageContent(phase)
        }
    }
}

public struct DSAsyncImageContent: View {
    
    var phase: AsyncImagePhase
    
    public init(_ phase: AsyncImagePhase) {
        self.phase = phase
    }
    
    public var body: some View {
        switch phase {
        case .success(let image):
            image
                .resizable()
                .padding(ds: .medium)
                .scaledToFill()
        case .failure(let error):
            Text(error.localizedDescription)
        default:
            ProgressView()
        }
    }
}
