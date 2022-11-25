//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 25/11/22.
//

import Foundation
import SwiftUI

public extension View {
    func isLoading(_ isLoading: Bool) -> some View {
        self
            .environment(\.isLoading, isLoading)
    }
    
    func isLoading(_ isLoading: Binding<Bool>) -> some View {
        self
            .modifier(isLoadingModifier(isLoading: isLoading))
    }
    
    func withLoader(
        style: DSLoadingStyle = .default
    ) -> some View {
        self
            .modifier(style.loadingModifier)
    }
    
    func withLoader(
        style: DSLoadingStyle = .default,
        isLoading: Binding<Bool>
    ) -> some View {
        self
            .modifier(style.loadingModifier)
            .isLoading(isLoading)
    }
    
    func withLoader(
        style: DSLoadingStyle = .default,
        isLoading: Bool
    ) -> some View {
        self
            .modifier(style.loadingModifier)
            .isLoading(isLoading)
    }

}
