//
//  File.swift
//
//
//  Created by Bruno Fulber Wide on 26/07/22.
//

import Foundation
import SwiftUI
import Combine

public struct DSPicker<Content: View, ID: Hashable>: View {
    
    @ObservedObject var vm: DSPickerSelectionViewModel
    @Binding var selection: ID?
    public var content: () -> Content
    
    public init(selection: Binding<ID?>,
         @DSPickerBuilder content: @escaping () -> Content) {
        self.content = content
        self._selection = selection
        self.vm = DSPickerSelectionViewModel(
            selection: selection.wrappedValue
        )
    }

    public var body: some View {
        content()
            .environmentObject(vm)
            .onChange(of: vm.selection) { newValue in
                selection = newValue as? ID
            }
    }
}

@resultBuilder
public enum DSPickerBuilder {
    
    public static func buildFinalResult<Content: View>(_ content: Content) -> some View {
        VStack(spacing: .ds.spacing.small) {
            content
        }
        .padding(.horizontal, ds: .medium)
    }
    
    public static func buildBlock<Content: View>(
        _ components: Content...
    ) -> ForEach<Range<Int>, Int, DSRowPickerItem<Content>> {
        ForEach(0..<components.count, id: \.self) { index in
            DSRowPickerItem {
                components[index]
            }
            .withTag(index)
        }
    }
    
    public static func buildBlock<ID, Data, Content>(
        _ loop: ForEach<Data, ID, Content>
    ) -> some View where ID: Hashable, Data: RandomAccessCollection, Data.Element: Identifiable, Content: View {
        ForEach(loop.data) { data in
            DSRowPickerItem {
                loop.content(data)
            }
            .withTag(data.id)
        }
    }
    
    public static func buildBlock<ID, Data, Content>(
        _ loop: ForEach<Data, ID, Content>
    ) -> some View where ID: Hashable, Data: RandomAccessCollection, Content: View {
        ForEach(0..<loop.data.count, id: \.self) { index in
            let data = loop.data[index as! Data.Index]
            DSRowPickerItem {
                loop.content(data)
            }
            .withTag(index)
        }
    }
}

class DSPickerSelectionViewModel: ObservableObject {
    @Published var selection: AnyHashable?
    
    init(selection: AnyHashable?) {
        self.selection = selection
    }
}

struct DSPickerPreview: PreviewProvider {
    @State static var selection: String? = "watermelon"
    @State static var items = [
        Fruit(name: "strawberry"),
        Fruit(name: "watermelon"),
        Fruit(name: "tomato")
    ]
    static var previews: some View {
        ZStack {
            Background(.secondary)
            DSPicker(selection: $selection) {
                ForEach(items) { fruit in
                    Text(fruit.name)
                }
            }
        }
    }
}

public struct Fruit: Identifiable {
    public init(name: String) {
        self.name = name
    }
    
    public var id: String { name }
    public var name: String
}
