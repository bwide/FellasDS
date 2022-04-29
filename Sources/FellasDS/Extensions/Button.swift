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
    case round
}

public extension Button {
    @ViewBuilder
    func style(_ style: DSButtonStyle) -> some View {
        switch style {
        case .pill:
            self
                .buttonStyle(DSPillButtonStyle())
        case .round:
            self
                .buttonStyle(DSRoundButtonStyle())
        }
    }
}

// MARK: - System Icon

public extension Button {
    init(systemIcon: String, action: @escaping () -> Void) where Label == Text {
        self.init("\(Image(systemName: systemIcon))",
                  action: action)
    }
}
