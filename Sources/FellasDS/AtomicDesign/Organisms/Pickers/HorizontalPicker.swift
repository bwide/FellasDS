//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 20/03/23.
//

import Foundation
import SwiftUI

public struct HorizontalPickerStyle: DSPickerStyle {
    public func makeBody(configuration: Configuration) -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: .ds.spacing.medium) {
                ForEach(configuration.views) { view in
                    DSHorizontalPickerItem {
                        view.body
                    }
                    .withTag(view.id)
                }
            }
        }
    }
}

struct DSHorizontalPickerItem<Content: View>: View, Taggable {
        
    @EnvironmentObject var vm: DSPickerSelection
    var tag: AnyHashable = UUID()
    var content: () -> Content
    
    init(_ content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        content()
            .padding(ds: .xSmall)
            .background(style: .secondary)
            .cornerRadius(ds: .medium)
            .overlay {
                if selected {
                    RoundedRectangle(cornerRadius: .ds.cornerRadius.medium)
                        .strokeBorder(Color.ds.brand.tertiary, lineWidth: 3)
                }
            }
            .onTapGesture { onTapGesture() }
    }
}

extension DSHorizontalPickerItem {
    
    internal init(content: @escaping () -> Content,
                  tag: AnyHashable) {
        self.content = content
        self.tag = tag
    }
    
    func withTag(_ tag: AnyHashable) -> DSHorizontalPickerItem<Content> {
        DSHorizontalPickerItem(content: content, tag: tag)
    }
}

struct HorizontalPicler_Previews: PreviewProvider {
    static var previews: some View {
        DSPicker {
            ForEach([1,2,3,4], id: \.self) { n in
                Text(String(stringLiteral: "\(n)"))
            }
        }
        .padding(.horizontal, ds: .medium)
        .dsPickerStyle(.horizontal)
    }
}
