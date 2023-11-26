//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 16/08/22.
//

import Foundation
import SwiftUI

#if os(iOS)

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func roundedCorners(_ radius: DSCornerRadius, corners: UIRectCorner = .allCorners) -> some View {
        clipShape( RoundedCorner(radius: radius.rawValue, corners: corners) )
    }
}

#endif
