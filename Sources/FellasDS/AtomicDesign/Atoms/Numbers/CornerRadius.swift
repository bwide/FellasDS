//
//  File.swift
//  
//
//  Created by Bruno Wide on 20/02/22.
//

import Foundation
import CoreGraphics
import SwiftUI

struct RoundViewModifier: ViewModifier {

    var axis: Axis

    func body(content: Content) -> some View {
        GeometryReader { geo in
            content
                .cornerRadius(axis == .horizontal ? geo.size.width/2 : geo.size.height/2, antialiased: true)
        }
    }
}

extension View {
    /// returns a view with semi-circles on it's vertical or horizontal edges
    func roundCorners(axis: Axis = .vertical) -> some View {
        modifier(RoundViewModifier(axis: axis))
    }
}

public enum DSCornerRadius: CGFloat, CaseIterable {

    case xSmall = 4
    case small = 8
    case medium = 16
    case large = 24
    
    static func round(width: CGFloat) -> CGFloat { width/2 }
}

public struct DSCornerRadii {
    
    /// small: 4
    public var xSmall = DSCornerRadius.small.rawValue
    /// small: 8
    public var small = DSCornerRadius.small.rawValue
    /// medium: 16
    public var medium = DSCornerRadius.medium.rawValue
    /// large: 24
    public var large = DSCornerRadius.large.rawValue

    public func round(width: CGFloat) -> CGFloat { DSCornerRadius.round(width: width) }
}
