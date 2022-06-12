//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 12/06/22.
//

import Foundation
import CoreGraphics

public enum DSSize: CGFloat, CaseIterable {
    case small = 30
    case medium = 60
    case large = 90
}

public struct DSSizes {
    public let small = DSSize.small.rawValue
    public let medium = DSSize.medium.rawValue
    public let large = DSSize.large.rawValue
}
