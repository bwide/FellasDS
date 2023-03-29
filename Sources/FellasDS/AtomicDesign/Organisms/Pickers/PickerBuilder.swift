//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 21/03/23.
//

import Foundation
import SwiftUI

public struct TagView: View, Identifiable {
    var label: AnyView
    public var id: AnyHashable
    
    public var body: some View {
        label
    }
}

@resultBuilder
public enum VerticalPickerBuilder {
    public static func buildFinalResult(_ component: [TagView]) -> DSPickerStyleConfiguration {
        .init(views: component)
    }
    
    public static func buildBlock<ID: Hashable, Data: RandomAccessCollection, Content: View>(
        _ loop: ForEach<Data, ID, Content>
    ) -> [TagView] {
        loop.data.enumerated().map {
            TagView(label: AnyView(loop.content($0.element)), id: $0.offset)
        }
    }
    
    public static func buildBlock<ID: Hashable, Data: RandomAccessCollection, Content: View>(
        _ loop: ForEach<Data, ID, Content>
    ) -> [TagView] where Data.Element: Hashable {
        loop.data.map {
            TagView(label: AnyView(loop.content($0)), id: $0)
        }
    }
    
    public static func buildBlock<Content: View>(
        _ contents: Content...
    ) -> [TagView] {
        contents.enumerated().map {
            TagView(label: AnyView($0.element), id: $0.offset)
        }
    }
}
