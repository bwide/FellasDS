//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 26/07/22.
//

import Foundation
import SwiftUI

protocol Taggable {
    var tag: AnyHashable { get set }
    var vm: DSPickerSelection { get }
    func withTag(_ tag: AnyHashable) -> Self
}

extension Taggable {
    var selected: Bool {
        tag == vm.selection
    }
    
    func onTapGesture() {
        if selected {
            vm.selection = nil
        } else {
            vm.selection = tag
        }
    }
}


public struct DSRowPickerItem<Content: View>: View, Taggable {
    
    public var content: () -> Content
    public var style: Style = .single
    public var backgroundStyle: BGStyle = .background
    
    var tag: AnyHashable = UUID()
    @EnvironmentObject var vm: DSPickerSelection
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        contentView
            .onTapGesture { onTapGesture() }
    }
    
    @ViewBuilder
    var contentView: some View {
        HStack(spacing: .ds.spacing.xxSmall) {
            content()
            Spacer()
//            pickerImage
        }
        .textStyle(
            ds: .body,
            color: backgroundStyle.textColor
        )
        .padding(.horizontal, .ds.spacing.medium)
        .padding(.vertical, .ds.spacing.small)
        .background { backgroundStyle.backgroundColor }
        .clipShape(RoundedRectangle(cornerRadius: .ds.cornerRadius.medium))
        .overlay {
            if selected {
                RoundedRectangle(cornerRadius: .ds.cornerRadius.medium)
                    .strokeBorder(backgroundStyle.selectionOverlayColor, lineWidth: 3)
            }
        }
    }
    
    @ViewBuilder
    var pickerImage: some View {
        Image(systemName: style.image(selected: selected))
            .foregroundColor(.ds.text.background.primary)
            .textStyle(ds: .body)
    }
}


struct DSRowPickerItemPreview: PreviewProvider {
    static var previews: some View {
        ZStack {
            Background(.secondary)
            
            VStack {
                DSRowPickerItem(content: {
                    Text(verbatim: "teste")
                })
                
                DSRowPickerItem(content: {
                    Text(verbatim: "teste")
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
    
    enum BGStyle {
        case background, grouped
        
        var textColor: Color {
            switch self {
            case .grouped: .ds.text.grouped.primary
            case .background: .ds.text.background.primary
            }
        }
        
        var backgroundColor: Color {
            switch self {
            case .grouped: .ds.brand.secondary
            case .background: .ds.background.secondary
            }
        }
        
        var selectionOverlayColor: Color {
            switch self {
            case .grouped: .ds.text.grouped.secondary
            case .background: Color.ds.brand.tertiary
            }
        }
    }
    
    // MARK: - Internal initializers
    
    internal init(content: @escaping () -> Content,
                  style: DSRowPickerItem<Content>.Style,
                  backgroundStyle: DSRowPickerItem<Content>.BGStyle,
                  tag: AnyHashable) {
        self.content = content
        self.style = style
        self.backgroundStyle = backgroundStyle
        self.tag = tag
    }
    
    func backgroundStyle(_ backgroundStyle: DSRowPickerItem<Content>.BGStyle) -> DSRowPickerItem {
        DSRowPickerItem(content: content,
                        style: style,
                        backgroundStyle: backgroundStyle,
                        tag: tag)
    }
    
    func selection(_ style: DSRowPickerItem<Content>.Style) -> DSRowPickerItem {
        DSRowPickerItem(content: content,
                        style: style,
                        backgroundStyle: backgroundStyle,
                        tag: tag)
    }
    
    func withTag(_ tag: AnyHashable) -> DSRowPickerItem {
        DSRowPickerItem(content: content,
                        style: style,
                        backgroundStyle: backgroundStyle,
                        tag: tag)
    }
}
