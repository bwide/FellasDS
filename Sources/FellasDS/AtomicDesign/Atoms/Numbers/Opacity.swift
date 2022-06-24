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
    public var opaque = DSOpacity.opaque.rawValue
    public var disabled = DSOpacity.disabled.rawValue
    public var transparent = DSOpacity.transparent.rawValue
}
