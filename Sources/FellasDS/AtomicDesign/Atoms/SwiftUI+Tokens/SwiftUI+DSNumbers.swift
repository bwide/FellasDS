//
//  File.swift
//  
//
//  Created by Bruno Wide on 20/02/22.
//

import Foundation
import SwiftUI

public extension View {
    @inlinable func cornerRadius(ds radius: DSCornerRadius, antialiased: Bool = true) -> some View {
        cornerRadius(radius.rawValue, antialiased: antialiased)
    }
    @inlinable func padding(_ edges: Edge.Set = .all, ds length: DSSpacing) -> some View {
        padding(edges, length.rawValue)
    }
}

public extension CGFloat {
    static var ds = DSNumbers()
}

public struct DSNumbers {
    public var spacing = DSSpacings()
    public var opacity = DSOpacities()
    public var cornerRadius = DSCornerRadii()
}

//MARK: - Size
extension DSSize {
    var cgSize: CGSize {
        switch UITraitCollection.current.preferredContentSizeCategory {
        default:
            return CGSize(width: rawValue, height: rawValue)
        }
    }
}


extension CGSize {
    static var ds = DSSizes()
}

public extension View {
    func frame(ds size: DSSize, alignment: Alignment = .center) -> some View {
        frame(width: size.cgSize.width,
              height: size.cgSize.height,
              alignment: alignment)
    }
}
