//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 10/12/22.
//

import Foundation
import FellasLocalization

public enum Strings {
    
    // MARK: - Paywall
    
    static var subscribe: String {
        String(
            localized: "Subscribe",
            bundle: .module.localizedBundle,
            comment: "Subscribe <to this app>"
        )
    }
    
    static var `continue`: String {
        String(
            localized: "Continue",
            bundle: .module.localizedBundle,
            comment: "Continue <to app>"
        )
    }
    
    static var subscribeFreeTrial: String {
        String(
            localized: "start.free.trial",
            bundle: .module.localizedBundle,
            comment: "Start Free Trial"
        )
    }
    
    static var restore: String {
        String(
            localized: "restore",
            bundle: .module.localizedBundle,
            comment: "Restore"
        )
    }
    
    static var dayly: String {
        String(
            localized: "subscription.period.day",
            bundle: .module.localizedBundle,
            comment: "Daily"
        )
    }
    
    static var weekly: String {
        String(
            localized: "subscription.period.week",
            bundle: .module.localizedBundle,
            comment: "Weekly"
        )
    }
    
    static var monthly: String {
        String(
            localized: "subscription.period.month",
            bundle: .module.localizedBundle,
            comment: "Monthly"
        )
    }
    
    static var yearly: String {
        String(
            localized: "subscription.period.year",
            bundle: .module.localizedBundle,
            comment: "Yearly"
        )
    }
    
    static var unknown: String {
        String(
            localized: "subscription.period.unknown",
            bundle: .module.localizedBundle,
            comment: "Unknown"
        )
    }
    
    static var freeTrialToggle: String {
        String(
            localized: "free.trial.toggle",
            bundle: .module.localizedBundle,
            comment: "Enable 3-Day Free Trial"
        )
    }
    
    static var paywallTitle: String {
        String(
            localized: "paywall.title",
            bundle: .module.localizedBundle,
            comment: "Get Premium <features>"
        )
    }
    
    static var termsOfUse: String {
        String(
            localized: "paywall.terms.of.use",
            bundle: .module.localizedBundle,
            comment: "Terms of Use"
        )
    }
    
    static var privacyPolicy: String {
        String(
            localized: "paywall.privacy.policy",
            bundle: .module.localizedBundle,
            comment: "Privacy Policy"
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
    
    public static var noProduct: String {
        String(
            localized: "no.product.found",
            bundle: .module.localizedBundle,
            comment: "No product found"
        )
    }
    
    public static var success: String {
        String(
            localized: "success",
            bundle: .module.localizedBundle,
            comment: "Success!"
        )
    }
    
    public static var restoreAlertError: String {
        String(
            localized: "restore.alert.error",
            bundle: .module.localizedBundle,
            comment: "Could not restore purchases."
        )
    }
    
    public static var restoreAlertSuccessPremium: String {
        String(
            localized: "restore.alert.success.premium",
            bundle: .module.localizedBundle,
            comment: "Successfully restored purchases!"
        )
    }
    
    public static var restoreAlertSuccessNotPremium: String {
        String(
            localized: "restore.alert.success.not.premium",
            bundle: .module.localizedBundle,
            comment: "No purchases found for this account"
        )
    }
    
    public static var restoreAlert: String {
        String(
            localized: "restore.alert.error",
            bundle: .module.localizedBundle,
            comment: "Could not restore purchases."
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
    
    static var yearlyDiscount: String {
        String(
            localized: "yearly.discount",
            bundle: .module.localizedBundle,
            comment: "2 Months off!"
        )
    }
}
