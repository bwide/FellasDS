//
//  File.swift
//  
//
//  Created by Bruno Wide on 09/03/22.
//

import Foundation
import SwiftUI

struct ColorsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: .ds.spacing.large) {
                section(for: DSBackgroundColor.allCases, title: "Background Colors")
                section(for: DSTextColor.allCases, title: "Text Colors")
                section(for: DSBrandColor.allCases, title: "Brand Colors")
                section(for: DSFeedbackColor.allCases, title: "Feedback")
            }
            .frame(maxWidth: .infinity)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, .ds.spacing.large)
        }
    }
    
    @ViewBuilder
    func section<Color: DSColor>(for colors: [Color], title: String) -> some View where Color: RawRepresentable<String>, Color: Hashable {
        Text(verbatim: title)
            .textStyle(ds: .title1)
        ForEach(colors, id: \.self) { style in
            cell(style: style)
        }
    }

    @ViewBuilder
    func cell(style: DSColor) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: .ds.cornerRadius.medium)
                .frame(width: 60, height: 60)
                .foregroundColor(style.color)
            Text(style.rawValue)
            Spacer()
        }
    }
}

struct ColorStylesPreview: PreviewProvider {
    static var previews: some View {
        Group {
            ColorsView()
        }
        .preferredColorScheme(.dark)
    }
}
