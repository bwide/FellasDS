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
    
    var error: String {
        NSLocalizedString(
            "Error",
            bundle: .module,
            comment: "error alert title"
        ).localizedCapitalized
    }
    
    var ok: String {
        NSLocalizedString(
            "OK",
            bundle: .module,
            comment: "dismiss alert button"
        ).localizedCapitalized
    }
    
    var cancel: String {
        NSLocalizedString(
            "cancel",
            bundle: .module,
            comment: "Cancel"
        ).localizedCapitalized
    }
    
    var rate: String {
        NSLocalizedString(
            "rate",
            bundle: .module,
            comment: "rate"
        ).localizedCapitalized
    }
    
    var sendFeedback: String {
        NSLocalizedString(
            "sendFeedback.button",
            bundle: .module,
            comment: "Send feedback"
        ).localizedCapitalized
    }
    
    var reviewPromptMessage: String {
        NSLocalizedString(
            "reviewprompt.message",
            bundle: .module,
            comment: "If you like our app, consider giving it a review, you can also send us any feedback through email"
        ).localizedCapitalized
    }
    
    var reviewPromptTitle: String {
        let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
        ?? "this app"
        
        let ans = NSLocalizedString(
            "reviewPrompt.title",
            bundle: .module,
            comment: "enjoying %@?"
        ).localizedCapitalized
        
        return String(format: ans, appName)
    }
}

// TODO: not sure if i can inject a localization from code

extension String {
    static let s = Strings()
}
