//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 12/07/24.
//

import Foundation
import SwiftUI

// current:
// https://stackoverflow.com/questions/62588015/get-the-current-scroll-position-of-a-swiftui-scrollview
// ideal:
// https://stackoverflow.com/questions/68681075/how-do-i-detect-when-user-has-reached-the-bottom-of-the-scrollview

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
 
    static var defaultValue = CGFloat.zero
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

public extension View {
    func onScrollsTo(offset: CGFloat, inCoordinateSpace coordinateSpace: String, didScrollToOffSet: (() -> Void)? = nil) -> some View {
        modifier(ScrollViewContentModifier(coordinateSpace: coordinateSpace, triggerOffset: offset, didScrollToOffSet: didScrollToOffSet))
    }
}

struct ScrollViewContentModifier: ViewModifier {
    
    var coordinateSpace: String
    var triggerOffset: CGFloat
    
    var didScrollToOffSet: (() -> Void)?
    
    @State var offset: CGFloat = .zero
    @State private var size: CGSize = .zero
    
    func body(content: Content) -> some View {
        content
            .readSize($size)
            .background( // read offset
                GeometryReader {
                    Color.clear.preference(
                        key: ViewOffsetKey.self,
                        value: offset(for: $0)
                    )
                })
            .onPreferenceChange(ViewOffsetKey.self) { // update offset
                offset = $0
            }
            .onChange(of: offset) { oldValue, newValue in
                if newValue >= triggerOffset {
                    didScrollToOffSet?()
                }
            }
    }
    
    func offset(for proxy: GeometryProxy) -> CGFloat {
        (
            -proxy.frame(in: .named(coordinateSpace)).origin.y / proxy.size.height
        ).rounded(toPlaces: 1)
    }
}
