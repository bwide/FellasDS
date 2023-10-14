//
//  ReviewAlert+Extensions.swift
//  PDFScanner
//
//  Created by Bruno Fulber Wide on 08/09/23.
//

import Foundation
import SwiftUI
import OSLog

let logger = Logger(subsystem: "Storekit", category: "Review")

public extension View {
    /**
        Sets up  reviewAlertService environment key
     
     - Parameters:
     allowsReviewPrompt: allows or blocks review alerts, defaults to true
     */
    func withReviewAlertService(allowsReviewPrompt: Bool = true) -> some View {
        modifier(ReviewAlertModifier(allowsReviewPrompt: allowsReviewPrompt))
    }
}

// MARK: - Service

public class ReviewAlertService: ObservableObject {
    
    var allowsReviewPrompt: Bool
    @Published var isPresented = false
    
    init(allowsReviewPrompt: Bool) {
        self.allowsReviewPrompt = allowsReviewPrompt
    }
    
    // MARK: - Public
    public func presentReviewPrompt() {
        guard canShowPrompt else {
            logger.log("can't show prompt until: \(self.dateForNextPrompt.formatted(.dateTime))")
            return
        }

        isPresented = true
        lastPrompt = .distantPast
    }
    
    // MARK: - Private
    
    private var lastPrompt: Date {
        get {
            guard
                let ans = UserDefaults.standard.object(forKey: "lastPrompt") as? Date
            else {
                return Date.now
            }
            
            return ans
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "lastPrompt")
        }
    }
    
    private var dateForNextPrompt: Date {
        get {
            guard 
                let ans =
                    UserDefaults.standard.object(forKey: "nextPrompt") as? Date else
            {
                return Date.now
            }
            return ans
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "nextPrompt")
        }
    }
    
    private var canShowPrompt: Bool {
        allowsReviewPrompt &&
        dateForNextPrompt.timeIntervalSinceReferenceDate <
        lastPrompt.timeIntervalSinceReferenceDate
    }
    
    fileprivate func handlePositiveFeedback() {
        let components = DateComponents(month: 3)
        dateForNextPrompt = Calendar.current.date(byAdding: components, to: .now) ?? .now
    }
    
    fileprivate func handleNegativeFeedback() {
        let components = DateComponents(day: 3)
        dateForNextPrompt = Calendar.current.date(byAdding: components, to: .now) ?? .now
    }
}

// MARK: - Views

struct ReviewAlertModifier: ViewModifier {
    
    var allowsReviewPrompt: Bool
    @Environment(\.reviewAlertService) var service: ReviewAlertService
    @State var isPresented = false
    
    func body(content: Content) -> some View {
        content
            .appStoreReviewAlert($isPresented, onNegativeReview: {
                service.handleNegativeFeedback()
            }, onPositiveReview: {
                service.handlePositiveFeedback()
            })
            .onReceive(service.$isPresented) { isPresented = $0 }
            .environment(
                \.reviewAlertService,
                 ReviewAlertService(allowsReviewPrompt: allowsReviewPrompt)
            )
    }
}

// MARK: - Environment Key

public struct ReviewAlertServiceKey: EnvironmentKey {
    public static var defaultValue: ReviewAlertService = .init(allowsReviewPrompt: true)
}

public extension EnvironmentValues {
    fileprivate(set) var reviewAlertService: ReviewAlertService {
        get { self[ReviewAlertServiceKey.self] }
        set { self[ReviewAlertServiceKey.self] = newValue }
    }
}



