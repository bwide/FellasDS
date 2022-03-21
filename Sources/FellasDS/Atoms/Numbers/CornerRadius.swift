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
                .cornerRadius(axis == .horizontal ? geo.size.width/2 : geo.size.height/2)
        }
    }
}

extension View {
    func roundCorners(axis: Axis = .vertical) -> some View {
        modifier(RoundViewModifier(axis: axis))
    }
}

public enum DSCornerRadius: CGFloat, CaseIterable {
    case small = 9
    case medium = 16
    case large = 24
    
    static func round(width: CGFloat) -> CGFloat { width/2 }
}

public struct DSCornerRadii {
    public var small = DSCornerRadius.small.rawValue
    public var medium = DSCornerRadius.medium.rawValue
    public var large = DSCornerRadius.large.rawValue

    public func round(width: CGFloat) -> CGFloat { DSCornerRadius.round(width: width) }
}
