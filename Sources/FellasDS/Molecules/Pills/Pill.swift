//
//  File.swift
//  
//
//  Created by Bruno Wide on 14/03/22.
//

import Foundation
import SwiftUI

struct Pill: View {

    var text: String = ""

    var body: some View {
        Text("Pill")
            .style(.headline)
            .padding(.vertical, .ds.spacing.xSmall)
            .padding(.horizontal, .ds.spacing.medium)
            .background(background)
    }

    var background: some View {
        Rectangle()
            .fill(Color.ds.brand.primary)
            .roundCorners()
            .frame(minWidth: .ds.spacing.xxxLarge)
    }
}

struct PillPreview: PreviewProvider {
    static var previews: some View {
        Group {
            Pill()
                .preferredColorScheme(.dark)
            Pill()
                .preferredColorScheme(.light)
        }
    }
}

