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
    
    @StateObject var vm: DSPickerSelectionViewModel = DSPickerSelectionViewModel()
    @Binding var selection: ID?
    public var content: () -> Content
    
    public init(selection: Binding<ID?>,
         @DSPickerBuilder content: @escaping () -> Content) {
        self._selection = selection
        self.content = content
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
    public static func buildBlock<Content: View>(_ components: Content...) -> some View {
        VStack {
            ForEach(0..<components.count, id: \.self) { index in
                DSRowPickerItem {
                    components[index]
                }
            }
        }
        .padding(.horizontal, ds: .medium)
    }
    
    public static func buildBlock<ID, Data, Content>(
        _ loop: ForEach<Data, ID, Content>
    ) -> some View where ID: Hashable, Data: RandomAccessCollection, Data.Element: Identifiable, Content: View {
        VStack(spacing: .ds.spacing.small) {
            ForEach(loop.data) { data in
                DSRowPickerItem {
                    loop.content(data)
                }
                .withTag(data.id)
            }
        }
        .padding(.horizontal, ds: .medium)
    }
    
    public static func buildBlock<ID, Data, Content>(
        _ loop: ForEach<Data, ID, Content>
    ) -> some View where ID: Hashable, Data: RandomAccessCollection, Content: View {
        VStack(spacing: .ds.spacing.small) {
            ForEach(0..<loop.data.count, id: \.self) { index in
                let data = loop.data[index as! Data.Index]
                DSRowPickerItem {
                    loop.content(data)
                }
                .withTag(index)
            }
        }
        .padding(.horizontal, ds: .medium)
    }
}

class DSPickerSelectionViewModel: ObservableObject {
    @Published var selection: AnyHashable? {
        didSet {
            print(selection)
        }
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
