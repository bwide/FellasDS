//
//  ReviewAlert+Extensions.swift
//  PDFScanner
//
//  Created by Bruno Fulber Wide on 08/09/23.
//

import Foundation
import SwiftUI
import OSLog
import Combine

let logger = Logger(subsystem: "Storekit", category: "Review")

public extension View {
    /**
        Sets up  reviewAlertService environment key
     
     - Parameters:
     allowsReviewPrompt: allows or blocks review alerts, defaults to true
     */
    func withReviewAlertService(
        allowsReviewPrompt: Bool = true,
        promptPositiveCooldown: DateComponents,
        promptNegativeCooldown: DateComponents
    ) -> some View {
        modifier(
            ReviewAlertModifier(
                allowsReviewPrompt: allowsReviewPrompt,
                promptPositiveCooldown: promptPositiveCooldown,
                promptNegativeCooldown: promptNegativeCooldown
            )
        )
    }
}

// MARK: - Service

public protocol Reviewable {
    init(
        allowsReviewPrompt: Bool,
        promptPositiveCooldown: DateComponents,
        promptNegativeCooldown: DateComponents
    )
    
    var isPresentedPublisher: Published<Bool>.Publisher { get }
    
    func presentReviewPrompt()
    func handlePositiveFeedback()
    func handleNegativeFeedback()
}

public class ReviewAlertService: ObservableObject, Reviewable {
    
    var allowsReviewPrompt: Bool
    var promptPositiveCooldown: DateComponents
    var promptNegativeCooldown: DateComponents
    
    @Published var isPresented = false
    
    public var isPresentedPublisher: Published<Bool>.Publisher { $isPresented }
    
    required public init(
        allowsReviewPrompt: Bool,
        promptPositiveCooldown: DateComponents,
        promptNegativeCooldown: DateComponents
    ) {
        self.allowsReviewPrompt = allowsReviewPrompt
        self.promptPositiveCooldown = promptPositiveCooldown
        self.promptNegativeCooldown = promptNegativeCooldown
    }
    
    // MARK: - Public
    public func presentReviewPrompt() {
        guard canShowPrompt else {
            logger.log("can't show prompt until: \(self.dateForNextPrompt.formatted(.dateTime))")
            return
        }

        isPresented = false
        isPresented = true
    }
    
    // MARK: - Private
    
    private var dateForNextPrompt: Date {
        get {
            guard 
                let ans =
                    UserDefaults.standard.object(forKey: "nextPrompt") as? Date else
            {
                return Date.distantPast
            }
            return ans
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "nextPrompt")
        }
    }
    
    private var canShowPrompt: Bool {
        allowsReviewPrompt &&
        dateForNextPrompt.timeIntervalSinceReferenceDate < Date.now.timeIntervalSinceReferenceDate
    }
    
    public func handlePositiveFeedback() {
        dateForNextPrompt = Calendar.current.date(byAdding: promptPositiveCooldown, to: .now) ?? .now
    }
    
    public func handleNegativeFeedback() {
        dateForNextPrompt = Calendar.current.date(byAdding: promptNegativeCooldown, to: .now) ?? .now
    }
}

// MARK: - Views

struct ReviewAlertModifier: ViewModifier {
    
    var allowsReviewPrompt: Bool
    var promptPositiveCooldown: DateComponents
    var promptNegativeCooldown: DateComponents
    
    @State var service: any Reviewable
    @State var isPresented = false
    
    init(
        allowsReviewPrompt: Bool,
        promptPositiveCooldown: DateComponents,
        promptNegativeCooldown: DateComponents
    ) {
        self.allowsReviewPrompt = allowsReviewPrompt
        self.promptPositiveCooldown = promptPositiveCooldown
        self.promptNegativeCooldown = promptNegativeCooldown
        self._service = State(
            wrappedValue: ReviewAlertService(
                allowsReviewPrompt: allowsReviewPrompt,
                promptPositiveCooldown: promptPositiveCooldown,
                promptNegativeCooldown: promptNegativeCooldown
            )
        )
    }
    
    func body(content: Content) -> some View {
        content
            .environment(\.reviewAlertService, service)
            .appStoreReviewAlert($isPresented, onNegativeReview: {
                service.handleNegativeFeedback()
            }, onPositiveReview: {
                service.handlePositiveFeedback()
            })
            .onReceive(service.isPresentedPublisher) {
                isPresented = $0
            }
    }
}

// MARK: - Environment Key

public struct ReviewAlertServiceKey: EnvironmentKey {
    public static var defaultValue: any Reviewable = NoOpReviewAlertService()
}

public extension EnvironmentValues {
    var reviewAlertService: any Reviewable {
        get { self[ReviewAlertServiceKey.self] }
        set { self[ReviewAlertServiceKey.self] = newValue }
    }
}

class NoOpReviewAlertService: ObservableObject, Reviewable {
    
    required init(allowsReviewPrompt: Bool, promptPositiveCooldown: DateComponents, promptNegativeCooldown: DateComponents) { }
    init() { }
    
    @Published var isPresented = false
    var isPresentedPublisher: Published<Bool>.Publisher { $isPresented }
    func presentReviewPrompt() { }
    func handlePositiveFeedback() { }
    func handleNegativeFeedback() { }
}

