//
//  File.swift
//  
//
//  Created by Bruno Wide on 08/03/22.
//

import Foundation
import SwiftUI

struct TypographiesView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: .ds.spacing.large) {
            ForEach(DSTypographyStyle.allCases, id: \.self) { style in
                Text(style.rawValue).style(style)
            }
        }
    }
}

struct FontStylesPreview: PreviewProvider {
    static var previews: some View {
        Group {
            TypographiesView()
        }
        .preferredColorScheme(.dark)
    }
}
