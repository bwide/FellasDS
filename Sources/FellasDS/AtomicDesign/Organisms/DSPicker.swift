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
    
    @State var vm: DSPickerSelectionViewModel
    public var content: () -> Content
    
    public init(selection: Binding<ID?>,
         @DSPickerBuilder content: @escaping () -> Content) {
        
        self.vm = DSPickerSelectionViewModel()
        self.content = content
    }

    public var body: some View {
        content()
            .environmentObject(vm)
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
    
    private var cancellables: Set<AnyCancellable> = .init()
}

struct DSPickerPreview: PreviewProvider {
    static var previews: some View {
        ZStack {
            Background(.secondary)
            DSPicker(selection: .constant(3)) {
                Text("teste")
                Text("teste")
            }
        }
    }
}
