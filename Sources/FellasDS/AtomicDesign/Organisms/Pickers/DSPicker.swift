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
    static var verticalBackground: VerticalPickerStyle { VerticalPickerStyle(grouped: false) }
    static var verticalGrouped: VerticalPickerStyle { VerticalPickerStyle(grouped: true) }
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
  static var defaultValue = AnyPickerStyle(style: VerticalPickerStyle(grouped: false))
}

extension EnvironmentValues {
  var pickerStyle: AnyPickerStyle {
    get { self[PickerStyleKey.self] }
    set { self[PickerStyleKey.self] = newValue }
  }
}

public struct DSPicker<ID: Hashable>: View {
    
    @Binding private var selection: ID
    @ObservedObject private var vm: DSPickerSelection
    private var content: () -> DSPickerStyleConfiguration
    
    @Environment(\.pickerStyle) var style
    
    public init(
        selection: Binding<ID> = .constant(0),
        @VerticalPickerBuilder content: @escaping () -> DSPickerStyleConfiguration
    ) {
        self._selection = selection
        self.content = content
        self.vm = DSPickerSelection(
            selection: selection.wrappedValue
        )
    }
    
    public var body: some View {
        style
            .makeBody(configuration: content())
            .environmentObject(vm)
            .onReceive(vm.$selection, perform: {
                guard let id = $0 as? ID else {
                    logger.log("Error receiving id \($0?.description ?? "")")
                    return
                }
                selection = id
            })
    }
}

public extension View {
    func dsPickerStyle<S: DSPickerStyle>(_ style: S) -> some View {
        environment(\.pickerStyle, AnyPickerStyle(style: style))
    }
}

class DSPickerSelection: ObservableObject {
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
            VStack {
                Background(.tertiary)
                Color.ds.brand.tertiary.ignoresSafeArea()
            }
            VStack {
                Spacer()
                
                Text(String(stringLiteral: "selected: \(selection ?? "")"))
                
                picker
                    .dsPickerStyle(.verticalBackground)
                
                picker
                    .dsPickerStyle(.horizontal)
                
                Spacer()
                
                picker
                    .dsPickerStyle(.verticalGrouped)
                
                Spacer()
            }
            .padding(.horizontal, ds: .medium)
        }
    }
    
    var picker: some View {
        DSPicker(selection: $selection) {
            ForEach(items) { fruit in
                Text(fruit.name)
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

#Preview {
    DSPickerPreview()
}
