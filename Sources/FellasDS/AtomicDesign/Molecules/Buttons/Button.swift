//
//  File.swift
//  
//
//  Created by Bruno Wide on 24/04/22.
//

import Foundation
import SwiftUI

// MARK: - Button Style

public enum DSButtonStyle {
    case pill
    case action
    case round
    case toolItem
}

public extension ButtonStyle where Self == DSPillButtonStyle {
    static var dsPill: DSPillButtonStyle { DSPillButtonStyle() }
}

public extension ButtonStyle where Self == DSActionButtonStyle {
    static var dsAction: DSActionButtonStyle { DSActionButtonStyle() }
}

public extension ButtonStyle where Self == DSRoundButtonStyle {
    static var dsRound: DSRoundButtonStyle { DSRoundButtonStyle() }
}

public extension ButtonStyle where Self == DSToolItemStyle {
    static var dsToolItem: DSToolItemStyle { DSToolItemStyle() }
}
