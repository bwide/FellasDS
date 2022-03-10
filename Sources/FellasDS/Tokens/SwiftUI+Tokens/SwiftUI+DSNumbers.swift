//
//  File.swift
//  
//
//  Created by Bruno Wide on 20/02/22.
//

import Foundation
import SwiftUI

public extension View {
    func cornerRadius(_ radius: DSCornerRadius) -> some View {
        self.cornerRadius(radius.rawValue)
    }

    func cornerRadius(_ radius: DSCornerRadius, antialiased: Bool) -> some View {
        self.cornerRadius(radius.rawValue, antialiased: antialiased)
    }
}

public extension CGFloat {
    public static var ds = DSNumbers()
}

public struct DSNumbers {
    public var spacing = DSSpacings()
    public var opacity = DSOpacities()
    public var cornerRadius = DSCornerRadii()
}
