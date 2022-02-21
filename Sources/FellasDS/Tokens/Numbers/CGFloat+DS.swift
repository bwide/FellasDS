//
//  File.swift
//  
//
//  Created by Bruno Wide on 20/02/22.
//

import Foundation
import CoreGraphics

public extension CGFloat {
    static var fds = FDSFloats()
}

public struct FDSFloats {
    public let spacings = FDSSpacings()

    public let cornerRadius = FDSCornerRadius()

    public let opacity = FDSOpacity()
}
