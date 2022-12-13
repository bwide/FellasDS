//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 10/12/22.
//

import Foundation

struct Strings {
    var subscribe: String {
        NSLocalizedString(
            "subscribe",
            bundle: .module,
            comment: "subscribe to this subscription button title"
        ).localizedCapitalized
    }
    
    var restore: String {
        NSLocalizedString(
            "restore",
            bundle: .module,
            comment: "restore purchases button title"
        ).localizedCapitalized
    }
    
    var privacyPolicy: String {
        NSLocalizedString(
            "privacy policy",
            bundle: .module,
            comment: "url link"
        ).localizedCapitalized
    }
    
    var termsOfUse: String {
        NSLocalizedString(
            "terms of use",
            bundle: .module,
            comment: "url link"
        ).localizedCapitalized
    }
}

// TODO: not sure if i can inject a localization from code

extension String {
    static let s = Strings()
}
