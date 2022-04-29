//
//  File.swift
//
//
//  Created by Bruno Wide on 25/01/22.
//

import Foundation
import SwiftUI

extension DSTypographyStyle {

    static func registerFont(bundle: Bundle, fontName: String, fontExtension: String = "otf") {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
            let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
            let font = CGFont(fontDataProvider) else {
                fatalError("Couldn't create font from filename: \(fontName) with extension \(fontExtension)")
        }
        var error: Unmanaged<CFError>?
        CTFontManagerRegisterGraphicsFont(font, &error)
    }

    static func registerFonts() {
        for fontName in DSFontNames.allCases.map({ $0.rawValue }) {
//            FDSFont.registerFont(bundle: .module, fontName: fontName)
            print(fontName)
        }
    }
}

enum DSFontNames: String, CaseIterable {
    case test = ""
}
