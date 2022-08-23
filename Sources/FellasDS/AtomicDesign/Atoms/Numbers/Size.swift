//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 12/06/22.
//

import Foundation
import CoreGraphics

public enum DSSize: CGFloat, CaseIterable {
    /// 30
    case small = 30
    /// 60
    case medium = 60
    /// 90
    case large = 90
    /// 180
    case x_large = 180
}

public struct DSSizes {
    /// 30
    public let small = DSSize.small.rawValue
    /// 60
    public let medium = DSSize.medium.rawValue
    /// 90
    public let large = DSSize.large.rawValue
    /// 180
    public let x_large = DSSize.x_large.rawValue
}
