//
//  File.swift
//  
//
//  Created by Bruno Wide on 09/03/22.
//

import Foundation
import SwiftUI

struct ColorStylesPreview: PreviewProvider {

    @ViewBuilder
    static func cell(style: DSColor) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: .ds.cornerRadius.medium)
                .frame(width: 60, height: 60)
                .foregroundColor(style.color)
            Text(style.rawValue)
            Spacer()
        }
    }

    static var previews: some View {
        Group {
            ScrollView {
                VStack(alignment: .leading, spacing: .ds.spacing.large) {
                    Text("Background Colors")
                        .style(.title1)
                    ForEach(DSBackgroundColor.allCases, id: \.self) { style in
                        cell(style: style)
                    }
                    Text("Text Colors")
                        .style(.title1)
                    ForEach(DSTextColor.allCases, id: \.self) { style in
                        cell(style: style)
                    }
                    Text("Brand Colors")
                        .style(.title1)
                    ForEach(DSBrandColor.allCases, id: \.self) { style in
                        cell(style: style)
                    }
                    Text("Feedback Colors")
                        .style(.title1)
                    ForEach(DSFeedbackColor.allCases, id: \.self) { style in
                        cell(style: style)
                    }
                }
                .frame(maxWidth: .infinity)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, .ds.spacing.large)
            }
        }
        .preferredColorScheme(.dark)
    }
}
