//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 16/08/22.
//

import Foundation
import SwiftUI

public struct BottomSheet<Label: View>: ViewModifier {
    
    @Binding public var isPresented: Bool
    public var label: () -> Label
    
    public init(isPresented: Binding<Bool>, @ViewBuilder label: @escaping () -> Label) {
        self._isPresented = isPresented
        self.label = label
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                background
                VStack {
                    Spacer()
                    label()
                        .fixedSize(horizontal: false, vertical: true)
                        .roundedCorners(.medium, corners: [.topRight, .topLeft])
                }
                .edgesIgnoringSafeArea(.bottom)
                .transition(.move(edge: .bottom))
                .animation(.default, value: isPresented)
            }
        }
    }
    
    @ViewBuilder
    var background: some View {
        Color.black.opacity(ds: .disabled)
            .ignoresSafeArea()
            .onTapGesture {
                isPresented = false
            }
    }
}

public extension View {
    func bottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(BottomSheet(isPresented: isPresented, label: content))
    }
}
