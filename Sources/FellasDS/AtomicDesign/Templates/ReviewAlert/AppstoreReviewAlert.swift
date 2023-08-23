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
    
    func body(content: Content) -> some View {
        content
            .alert(Strings.reviewPromptTitle, isPresented: $isPresented) {
                Button(Strings.sendFeedback) {
                    handleFeedback()
                }
                Button(Strings.rate) {
                    handleAppstoreReview()
                }
                Button(Strings.cancel, role: .cancel) {
                    handleCancel()
                }
            } message: {
                Text(Strings.reviewPromptMessage)
            }

    }
}
extension AppstoreReviewAlert {
    func handleAppstoreReview() {
        guard
            let scene = UIApplication.shared.keyWindow?.windowScene
        else {
            isPresented = false
            return
        }
        
        SKStoreReviewController.requestReview(in: scene)
    }
    
    func handleCancel() {
        isPresented = false
    }
    
    func handleFeedback() {
        let email = "fellas_support@icloud.com"
        guard let url = URL(string: "mailto:\(email)") else { return }
        UIApplication.shared.open(url)
    }
}

public extension View {
    func appStoreReviewAlert(_ isPresented: Binding<Bool>) -> some View {
        modifier(AppstoreReviewAlert(isPresented: isPresented))
    }
}

struct AppstoreReviewAlert_Preview: PreviewProvider {
    static var previews: some View {
        Background(.primary)
            .appStoreReviewAlert(.constant(true))
    }
}

