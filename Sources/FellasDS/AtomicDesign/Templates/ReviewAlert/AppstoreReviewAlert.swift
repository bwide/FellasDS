//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 19/12/22.
//

import Foundation
import SwiftUI
import StoreKit

struct AppstoreReviewAlert: ViewModifier {
    
    @Binding var isPresented: Bool
    
    var onNegativeReview: () -> Void
    var onPositiveReview: () -> Void
    
    @State private var isFeedbackPromptPresented: Bool = false
    
    func body(content: Content) -> some View {
        content
            .alert(
                Strings.reviewPromptTitle,
                isPresented: $isPresented
            ) {
                Button(Strings.yes) {
                    handlePositiveFeedback()
                }
                Button(Strings.no, role: .cancel) {
                    handleNegativeFeedback()
                }
            } message: {
                Text(Strings.reviewPromptMessage)
            }
            .alert(
                Strings.feedbackPromptTitle,
                isPresented: $isFeedbackPromptPresented
            ) {
                Button(Strings.feedbackPromptTitle) {
                    handleSendFeedback()
                }
                Button(Strings.cancel, role: .cancel) {
                    handleCancelFeedback()
                }
            } message: {
                Text(Strings.feedbackPromptMessage)
            }

    }
}

extension AppstoreReviewAlert {
    func handlePositiveFeedback() {
        guard
            let scene = UIApplication.shared.keyWindow?.windowScene
        else {
            isPresented = false
            return
        }
        
        SKStoreReviewController.requestReview(in: scene)
        onPositiveReview()
    }
    
    func handleNegativeFeedback() {
        isPresented = false
        isFeedbackPromptPresented = true
        onNegativeReview()
    }
    
    func handleCancelFeedback() {
        isFeedbackPromptPresented = false
    }
    
    func handleSendFeedback() {
        let email = "fellas_support@icloud.com"
        guard let url = URL(string: "mailto:\(email)") else { return }
        UIApplication.shared.open(url)
    }
}

extension View {
    func appStoreReviewAlert(
        _ isPresented: Binding<Bool>,
        onNegativeReview: @escaping () -> Void,
        onPositiveReview: @escaping () -> Void
    ) -> some View {
        modifier(AppstoreReviewAlert(
            isPresented: isPresented,
            onNegativeReview: onNegativeReview,
            onPositiveReview: onPositiveReview)
        )
    }
}


struct AppstoreReviewAlert_Preview: PreviewProvider {
    static var previews: some View {
        Background(.primary)
            .appStoreReviewAlert(.constant(true), onNegativeReview: {}, onPositiveReview: {})
    }
}

