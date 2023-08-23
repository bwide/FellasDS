//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 10/12/22.
//

import Foundation
import FellasLocalization

enum Strings {
    static var subscribe: String {
        String(
            localized: "subscribe",
            bundle: Locale.bundle,
            comment: "subscribe {x}"
        )
    }
    
    static var restore: String {
        String(
            localized: "restore",
            bundle: Locale.bundle,
            comment: "restore {x}"
        )
    }
    
    static var privacyPolicy: String {
        String(
            localized: "privacy policy",
            bundle: Locale.bundle,
            comment: "privacy policy"
        )
    }
    
    static var termsOfUse: String {
        String(
            localized: "terms of use",
            bundle: Locale.bundle,
            comment: "terms of use"
        )
    }
    
    static var error: String {
        String(
            localized: "Error",
            bundle: Locale.bundle,
            comment: "Error"
        )
    }
    
    static var ok: String {
        String(
            localized: "OK",
            bundle: Locale.bundle,
            comment: "OK"
        )
    }
    
    static var cancel: String {
        String(
            localized: "cancel",
            bundle: Locale.bundle,
            comment: "Cancel"
        )
    }
    
    static var rate: String {
        String(
            localized: "rate",
            bundle: Locale.bundle,
            comment: "rate {app}"
        )
    }
    
    static var sendFeedback: String {
        String(
            localized: "sendFeedback.button",
            bundle: Locale.bundle,
            comment: "Send feedback"
        )
    }
    
    static var reviewPromptMessage: String {
        String(
            localized: "reviewprompt.message",
            bundle: Locale.bundle,
            comment: "If you like our app, consider giving it a review, you can also send us any feedback through email"
        )
    }
    
    static var reviewPromptTitle: String {
        let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
        ?? "this app"
        
        let ans = String(
            localized: "localized.title",
            bundle: Locale.bundle,
            comment: "enjoying {x}%@?"
        )
        
        return String(format: ans, appName)
    }
}
