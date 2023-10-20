//
//  Alert.swift
//  
//
//  Created by Bruno Fulber Wide on 05/07/22.
//

import Foundation
import SwiftUI

public struct AlertModifier: ViewModifier {
    
    @Binding var error: Error?
    @State var isPresented: Bool = false
    
    public func body(content: Content) -> some View {
        content
            .alert(Strings.error, isPresented: .constant(error != nil)) {
                Button(Strings.ok, role: .none, action: { error = nil })
            } message: {
                Text(error?.localizedDescription ?? "")
            }
    }
}

public extension View {
    func alert(error: Binding<Error?>) -> some View {
        self
            .modifier(AlertModifier(error: error))
    }
}
