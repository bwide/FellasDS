//
//  File.swift
//  
//
//  Created by Bruno Wide on 08/03/22.
//

import Foundation
import SwiftUI

struct FontStylesPreview: PreviewProvider {
    static var previews: some View {
        Group {
            VStack(alignment: .leading, spacing: .ds.spacing.large) {
                ForEach(DSTypographyStyle.allCases, id: \.self) { style in
                    Text(style.rawValue).style(style)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
