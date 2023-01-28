//
//  File.swift
//  
//
//  Created by Bruno Wide on 25/04/22.
//

import Foundation
import SwiftUI

public struct ActionCardView: View {

    @ObservedObject var vm: ActionCardViewModel

    public var body: some View {
        content
            .padding(.ds.spacing.medium)
            .background(
                RoundedRectangle(cornerRadius: .ds.cornerRadius.medium)
                    .foregroundColor(.ds.background.secondary)
            )
    }

    @ViewBuilder
    var content: some View {
        VStack {
            HStack {
                Text(vm.title).textStyle(ds: .title2)
                Spacer()
                Button(action: {}) {
                    Image(systemName: vm.icon)
                }
                    .buttonStyle(.dsRound)
            }
            HStack {
                Text(vm.subtitle).textStyle(ds: .caption1)
                Spacer()
            }
            Spacer()
            HStack {
                Spacer()
                Text(vm.info).textStyle(ds: .title3)
            }
        }
    }
}

struct ActionCardPreview: PreviewProvider {
    static var previews: some View {
        Group {
            LazyVGrid(columns: [.init(), .init()]) {
                ForEach(0..<10, id: \.self) { _ in
                    ActionCardView(title: "title", subtitle: "subtitle", info: "info", icon: "plus")
                }
            }
            .padding()
        }
    }
}

