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
                Text("Title").style(.title2)
                Spacer()
                Button(systemIcon: "plus", action: { })
                    .style(.round)
            }
            HStack {
                Text("Subitle").style(.caption1)
                Spacer()
            }
            Spacer()
            HStack {
                Spacer()
                Text("Info").style(.title3)
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

