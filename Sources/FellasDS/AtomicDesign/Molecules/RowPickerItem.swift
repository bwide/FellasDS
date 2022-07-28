//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 26/07/22.
//

import Foundation
import SwiftUI

public struct DSRowPickerItem<Content: View>: View {
    
    public var content: () -> Content
    public var style: Style = .single
    
    internal var tag: AnyHashable = UUID()
    @EnvironmentObject var vm: DSPickerSelectionViewModel
    @State public var selected: Bool = false
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        HStack(spacing: .ds.spacing.xxSmall) {
            content()
            Spacer()
            pickerImage
        }
        .padding(.ds.spacing.medium)
        .background { Background(.primary) }
        .clipShape(RoundedRectangle(cornerRadius: .ds.cornerRadius.medium))
        .onTapGesture { selected.toggle() }
        .overlay {
            if selected {
                RoundedRectangle(cornerRadius: .ds.cornerRadius.medium)
                    .strokeBorder(.black, lineWidth: 3)
            }
        }
        .onChange(of: vm.selection) { newValue in
            selected = newValue == tag
        }
        .onChange(of: selected) { newValue in
            if newValue {
                vm.selection = tag
            }
        }
    }
    
    @ViewBuilder
    var pickerImage: some View {
        Image(systemName: style.image(selected: selected))
    }
}


struct DSRowPickerItemPreview: PreviewProvider {
    static var previews: some View {
        ZStack {
            Background(.secondary)
            
            VStack {
                DSRowPickerItem(content: {
                    Text("teste")
                })
                
                DSRowPickerItem(content: {
                    Text("teste")
                })
                .selection(.multiple)
            }
            .padding()
        }
    }
}

public extension DSRowPickerItem {
    enum Style {
        case single, multiple
        
        func image(selected: Bool) -> String {
            selected
            ? "checkmark.\(shape).fill"
            : shape
        }
        
        var shape: String {
            switch self {
            case .single: return "circle"
            case .multiple: return "square"
            }
        }
    }
    
    internal init(content: @escaping () -> Content,
                  selected: Bool,
                  style: DSRowPickerItem<Content>.Style,
                  tag: AnyHashable) {
        self.content = content
        self.selected = selected
        self.style = style
        self.tag = tag
    }
    
    func selection(_ style: DSRowPickerItem<Content>.Style) -> DSRowPickerItem {
        DSRowPickerItem(content: content,
                        selected: selected,
                        style: style,
                        tag: tag)
    }
    
    func tag(_ tag: AnyHashable) -> DSRowPickerItem {
        DSRowPickerItem(content: content,
                        selected: selected,
                        style: style,
                        tag: tag)
    }
    
    func isSelected(_ selected: Bool) -> DSRowPickerItem {
        DSRowPickerItem(content: content,
                        selected: selected,
                        style: style,
                        tag: tag)
    }
}
