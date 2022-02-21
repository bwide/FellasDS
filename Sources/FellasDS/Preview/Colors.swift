//
//  Colors.swift
//  
//
//  Created by Bruno Wide on 20/02/22.
//

import Foundation
import SwiftUI

struct ColorTokensView: View {
    var body: some View {
        VStack {
            Text("Background")
                .font(.fds.title1)
            square(with: .fds.background.tertiary)
            Text("Text")
                .font(.fds.title1)
            Text("Feedback")
                .font(.fds.title1)
            Text("Brand")
                .font(.fds.title1)
        }

    }

    @ViewBuilder
    func square(with color: Color) -> some View {
        RoundedRectangle(cornerRadius: .fds.cornerRadius.medium)
            .foregroundColor(color)
            .overlay(
                RoundedRectangle(cornerRadius: .fds.cornerRadius.medium)
                    .strokeBorder(lineWidth: 3)
            )
            .frame(width: 60, height: 60)
    }
}

struct ColorPreviews: PreviewProvider {

    static var previews: some View {
        Group {
            ColorTokensView()
        }
    }
}
