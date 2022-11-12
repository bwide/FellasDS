//
//  File.swift
//  
//
//  Created by Bruno Wide on 20/02/22.
//

import Foundation
import CoreGraphics

public enum DSOpacity: CGFloat, CaseIterable {
    case opaque = 1
    case disabled = 0.5
    case transparent = 0
}

public struct DSOpacities {
    /// opacity: 1
    public var opaque = DSOpacity.opaque.rawValue
    /// opacity: 0.5
    public var disabled = DSOpacity.disabled.rawValue
    /// opacity: 0
    public var transparent = DSOpacity.transparent.rawValue
}
