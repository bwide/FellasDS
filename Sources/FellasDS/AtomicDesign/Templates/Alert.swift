//
//  Alert.swift
//  
//
//  Created by Bruno Fulber Wide on 05/07/22.
//

import Foundation
import SwiftUI

public struct AlertModifier<ErrorType: Error & CustomStringConvertible>: ViewModifier {
    
    @Binding var error: ErrorType?
    @State var isPresented: Bool = false
    
    public func body(content: Content) -> some View {
        content
            .alert("Error", isPresented: .constant(error != nil)) {
                Button("ok", role: .none, action: { error = nil })
            } message: {
                Text(error?.description ?? "")
            }
    }
}

public extension View {
    func alert<ErrorType: Error & CustomStringConvertible>(error: Binding<ErrorType?>) -> some View {
        self
            .modifier(AlertModifier(error: error))
    }
}
