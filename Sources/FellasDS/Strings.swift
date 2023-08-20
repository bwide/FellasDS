//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 10/12/22.
//

import Foundation
import FellasLocalization

struct Strings {
    var subscribe: String {
        String.localizable(
            key: "subscribe",
            text: "subscribe {x}"
        )
    }
    
    var restore: String {
        String.localizable(
            key: "restore",
            text: "restore {x}"
        )
    }
    
    var privacyPolicy: String {
        String.localizable(
            key: "privacy policy",
            text: "privacy policy"
        )
    }
    
    var termsOfUse: String {
        String.localizable(
            key: "terms of use",
            text: "terms of use"
        )
    }
    
    var error: String {
        String.localizable(
            key: "Error",
            text: "Error"
        )
    }
    
    var ok: String {
        String.localizable(
            key: "OK",
            text: "OK"
        )
    }
    
    var cancel: String {
        String.localizable(
            key: "cancel",
            text: "Cancel"
        )
    }
    
    var rate: String {
        String.localizable(
            key: "rate",
            text: "rate {app}"
        )
    }
    
    var sendFeedback: String {
        String.localizable(
            key: "sendFeedback.button",
            text: "Send feedback"
        )
    }
    
    var reviewPromptMessage: String {
        String.localizable(
            key: "reviewprompt.message",
            text: "If you like our app, consider giving it a review, you can also send us any feedback through email"
        )
    }
    
    var reviewPromptTitle: String {
        let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
        ?? "this app"
        
        let ans = String.localizable(
            key: "reviewPrompt.title",
            text: "enjoying {x}%@?"
        )
        
        return String(format: ans, appName)
    }
    
    func introductoryOffer(period: String) -> String {
        let ans = String.localizable(
            key: "subscription.offer",
            text: "free for {x}%@"
        )
        return String(format: ans, period)
    }
}

extension String {
    static let s = Strings()
}
