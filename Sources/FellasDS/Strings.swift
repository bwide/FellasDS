//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 10/12/22.
//

import Foundation

struct Strings {
    var subscribe = localizable(
        key: "subscribe",
        text: "subscribe {x}"
    )
    
    var restore = localizable(
        key: "restore",
        text: "restore {x}"
    )
    
    var privacyPolicy = localizable(
        key: "privacy policy",
        text: "privacy policy"
    )
    
    var termsOfUse = localizable(
        key: "terms of use",
        text: "terms of use"
    )
    
    var error = localizable(
        key: "Error",
        text: "Error"
    )
    
    var ok = localizable(
        key: "OK",
        text: "OK"
    )
    
    var cancel = localizable(
        key: "cancel",
        text: "Cancel"
    )
    
    var rate = localizable(
        key: "rate",
        text: "rate {app}"
    )
    
    var sendFeedback = localizable(
        key: "sendFeedback.button",
        text: "Send feedback"
    )
    
    var reviewPromptMessage = localizable(
        key: "reviewprompt.message",
        text: "If you like our app, consider giving it a review, you can also send us any feedback through email"
    )
    
    var reviewPromptTitle: String {
        let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
        ?? "this app"
        
        let ans = Self.localizable(
            key: "reviewPrompt.title",
            text: "enjoying {x}%@?"
        )
        
        return String(format: ans, appName)
    }
    
    func introductoryOffer(period: String) -> String {
        let ans = Self.localizable(
            key: "subscription.offer",
            text: "free for {x}%@"
        )
        return String(format: ans, period)
    }
}

extension String {
    static let s = Strings()
}

extension Strings {
    static func localizable(key: String, text: String) -> String {
        NSLocalizedString(
            key,
            bundle: .module,
            comment: text
        ).localizedCapitalized
    }
}
