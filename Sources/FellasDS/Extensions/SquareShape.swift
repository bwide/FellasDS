//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 02/07/24.
//

import Foundation
import SwiftUI

struct Square: Shape {
    func path(in rect: CGRect) -> Path {
        let side = min(rect.width, rect.height)
        let diff = abs(rect.height - rect.width)
        
        let originX = rect.width > rect.height ? diff/2 : 0
        let originY = rect.height > rect.width ? diff/2 : 0
        
        let squareRect = CGRect(
            x: originX, y: originY,
            width: side, height: side
        )
        
        return Path.init(roundedRect: squareRect, cornerSize: .zero)
    }
}


#Preview(body: {
    Text("test")
        .padding(ds: .large)
        .background(Color.blue)
        .clipShape(Square())
})
