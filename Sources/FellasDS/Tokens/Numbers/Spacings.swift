//
//  Spacings.swift
//  
//
//  Created by Bruno Wide on 20/02/22.
//

import Foundation
import CoreGraphics

public enum DSSpacing: CGFloat, CaseIterable {
    /// xxxs spacing: 2
    case xxxSmall = 2
    /// xxs spacing: 4
    case xxSmall = 4
    /// xs spacing: 8
    case xSmall = 8
    /// sm spacing: 12
    case small = 12
    /// md spacing: 16
    case medium = 16
    /// lg spacing: 24
    case large = 24
    /// xl spacing: 32
    case xLarge = 32
    /// xxl spacing: 48
    case xxLarge = 48
    /// xxxl spacing: 64
    case xxxLarge = 64
}

public struct DSSpacings {
    /// xxxs spacing: 2
    public var xxxSmall = DSSpacing.xxxSmall.rawValue
    /// xxs spacing: 4
    public var xxSmall = DSSpacing.xxSmall.rawValue
    /// xs spacing: 8
    public var xSmall = DSSpacing.xSmall.rawValue
    /// sm spacing: 12
    public var small = DSSpacing.small.rawValue
    /// md spacing: 16
    public var medium = DSSpacing.medium.rawValue
    /// lg spacing: 24
    public var large = DSSpacing.large.rawValue
    /// xl spacing: 32
    public var xLarge = DSSpacing.xLarge.rawValue
    /// xxl spacing: 48
    public var xxLarge = DSSpacing.xxLarge.rawValue
    /// xxxl spacing: 64
    public var xxxLarge = DSSpacing.xxxLarge.rawValue
}
