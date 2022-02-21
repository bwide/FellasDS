//
//  File.swift
//  
//
//  Created by Bruno Wide on 20/02/22.
//

import Foundation
import CoreGraphics

public struct FDSCornerRadius {
    public let small: CGFloat = 8
    public let medium: CGFloat = 16
    public let large: CGFloat = 24
    
    public func round(_ width: CGFloat) -> CGFloat { width/2 }
}
