//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 25/11/22.
//

import Foundation
import SwiftUI

private struct LoadingStatusKey: EnvironmentKey {
    static var defaultValue: Bool { false }
}

public extension EnvironmentValues {
    var isLoading: Bool {
        get {
            self[LoadingStatusKey.self]
        }
        set {
            self[LoadingStatusKey.self] = newValue
        }
    }
}

struct isLoadingModifier: ViewModifier {
    
    @Binding var isLoading: Bool
    
    func body(content: Content) -> some View {
        content
            .environment(\.isLoading, isLoading)
    }
}
