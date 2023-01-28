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
            comment: "subscribe {x}"
        ).localizedCapitalized
    }
    
    var restore: String {
        NSLocalizedString(
            "restore",
            bundle: .module,
            comment: "restore {x}"
        ).localizedCapitalized
    }
    
    var privacyPolicy: String {
        NSLocalizedString(
            "privacy policy",
            bundle: .module,
            comment: "privacy policy"
        ).localizedCapitalized
    }
    
    var termsOfUse: String {
        NSLocalizedString(
            "terms of use",
            bundle: .module,
            comment: "terms of use"
        ).localizedCapitalized
    }
    
    var error: String {
        NSLocalizedString(
            "Error",
            bundle: .module,
            comment: "Error"
        ).localizedCapitalized
    }
    
    var ok: String {
        NSLocalizedString(
            "OK",
            bundle: .module,
            comment: "OK"
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
            comment: "rate {app}"
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
            comment: "enjoying {x}%@?"
        ).localizedCapitalized
        
        return String(format: ans, appName)
    }
    
    func introductoryOffer(period: String) -> String {
        let ans = NSLocalizedString(
            "subscription.offer",
            bundle: .module,
            comment: "free for {x}%@"
        ).localizedCapitalized
        
        return String(format: ans, period)
    }
}

// TODO: not sure if i can inject a localization from code

extension String {
    static let s = Strings()
}
