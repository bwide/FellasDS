//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 20/03/23.
//

import Foundation
import SwiftUI

public protocol DSPickerStyle {
    associatedtype Body : View

    @ViewBuilder
    func makeBody(configuration: Configuration) -> Body

    /// The properties of a button.
    typealias Configuration = DSPickerStyleConfiguration
}

public extension DSPickerStyle where Self == VerticalPickerStyle {
    static var vertical: VerticalPickerStyle { VerticalPickerStyle() }
}

public extension DSPickerStyle where Self == HorizontalPickerStyle {
    static var horizontal: HorizontalPickerStyle { HorizontalPickerStyle() }
}

struct AnyPickerStyle: DSPickerStyle {
    private var _makeBody: (Configuration) -> AnyView
    
    init<S: DSPickerStyle>(style: S) {
        _makeBody = { configuration in
            AnyView(style.makeBody(configuration: configuration))
        }
    }

    func makeBody(configuration: Configuration) -> some View {
      _makeBody(configuration)
    }
}

public struct DSPickerStyleConfiguration {
    let views: [TagView]
}

struct PickerStyleKey: EnvironmentKey {
  static var defaultValue = AnyPickerStyle(style: VerticalPickerStyle())
}

extension EnvironmentValues {
  var pickerStyle: AnyPickerStyle {
    get { self[PickerStyleKey.self] }
    set { self[PickerStyleKey.self] = newValue }
  }
}

public struct DSPicker<ID: Hashable>: View {
    
    @Binding var selection: ID?
    @ObservedObject var vm: DSPickerSelectionViewModel
    var content: () -> DSPickerStyleConfiguration
    
    @Environment(\.pickerStyle) var style
    
    public init(
        selection: Binding<ID?> = .constant(0),
        @VerticalPickerBuilder content: @escaping () -> DSPickerStyleConfiguration
    ) {
        self._selection = selection
        self.content = content
        self.vm = DSPickerSelectionViewModel(
            selection: selection.wrappedValue
        )
    }
    
    public var body: some View {
        style
            .makeBody(configuration: content())
            .environmentObject(vm)
            .onChange(of: vm.selection) { newValue in
                selection = newValue as? ID
            }
    }
}

public extension View {
    func dsPickerStyle<S: DSPickerStyle>(_ style: S) -> some View {
        environment(\.pickerStyle, AnyPickerStyle(style: style))
    }
}

class DSPickerSelectionViewModel: ObservableObject {
    @Published var selection: AnyHashable?
    
    init(selection: AnyHashable?) {
        self.selection = selection
    }
}

public struct DSPickerPreview: View {
    @State var selection: String? = "watermelon"
    
    @State var items = [
        Fruit(name: "strawberry"),
        Fruit(name: "watermelon"),
        Fruit(name: "tomato")
    ]
    
    public var body: some View {
        ZStack {
            Background(.secondary)
            VStack {
                Text("selected: \(selection ?? "")")
                
                DSPicker(selection: $selection) {
                    ForEach(items) { fruit in
                        Text(fruit.name)
                    }
                }
                .dsPickerStyle(.vertical)
                
                DSPicker(selection: $selection) {
                    ForEach(items) { fruit in
                        Text(fruit.name)
                    }
                }
                .dsPickerStyle(.horizontal)
            }
        }
    }
}

public struct Fruit: Identifiable, CustomStringConvertible {
    public init(name: String) {
        self.name = name
    }
    
    public var id: String { name }
    public var name: String
    public var description: String { name }
}

struct DSPicker_Preview: PreviewProvider {
    static var previews: some View {
        DSPickerPreview()
    }
}
