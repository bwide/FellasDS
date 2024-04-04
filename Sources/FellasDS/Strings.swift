//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 10/12/22.
//

import Foundation
import FellasLocalization

public enum Strings {
    static var subscribe: String {
        String(
            localized: "Subscribe",
            bundle: .module.localizedBundle,
            comment: "subscribe <to this app>"
        )
    }
    
    static var restore: String {
        String(
            localized: "restore",
            bundle: .module.localizedBundle,
            comment: "Restore <purchases>"
        )
    }
    
    static var error: String {
        String(
            localized: "Error",
            bundle: .module.localizedBundle,
            comment: "Error"
        )
    }
    
    public static var ok: String {
        String(
            localized: "OK",
            bundle: .module.localizedBundle,
            comment: "OK"
        )
    }
    
    public static var cancel: String {
        String(
            localized: "cancel",
            bundle: .module.localizedBundle,
            comment: "Cancel"
        )
    }
    
    // MARK: - Review Prompt
    
    public static var yes: String {
        String(
            localized: "Yes",
            bundle: .module.localizedBundle,
            comment: "Yes"
        )
    }
    
    public static var no: String {
        String(
            localized: "No",
            bundle: .module.localizedBundle,
            comment: "No"
        )
    }
    
    static var reviewPromptMessage: String {
        String(
            localized: "Are you enjoying the app so far?",
            bundle: .module.localizedBundle,
            comment: "Are you enjoying the app so far?"
        )
    }
    
    static var reviewPromptTitle: String {
        let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
        ?? "this app"
        
        let ans = String(
            localized: "Rate %@?",
            bundle: .module.localizedBundle,
            comment: "Rate <our app>%@?"
        )
        
        return String(format: ans, appName)
    }
    
    // MARK: - Feedback prompt
    
    static var feedbackPromptTitle: String {
        String(
            localized: "Give Feedback",
            bundle: .module.localizedBundle,
            comment: "Give Feedback <about our app>"
        )
    }
    
    static var feedbackPromptMessage: String {
        String(
            localized: "Please take a moment to share feedback. It helps improving your experience.",
            bundle: .module.localizedBundle,
            comment: "Please take a moment to share feedback. It helps improving your experience."
        )
    }
    
    // MARK: - Onboarding
    
    static var onboardingOutroTitle: String {
        String(
            localized: "onboarding.outro.title",
            bundle: .module.localizedBundle,
            comment: "Personalizing your experience"
        )
    }
}
