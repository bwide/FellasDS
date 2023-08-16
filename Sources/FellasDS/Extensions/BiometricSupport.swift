//
//  BiometricSupport.swift
//  PDFScanner
//
//  Created by Bruno Fulber Wide on 11/08/23.
//

import Foundation
import LocalAuthentication

public enum BiometryType: String {
    case none
    case touchID
    case faceID
    case opticID
    
    public var icon: String {
        switch self {
        case .none:
            return "lock"
        case .touchID:
            return "touchid"
        case .faceID:
            return "faceid"
        case .opticID:
            return "opticid"
        }
    }
}

public extension LAContext {
    func withAuthentication(reason: String, _ completion: @escaping () -> Void) {
        Task {
            try await evaluatePolicy(
                preferredPolicy,
                localizedReason: reason
            )
            completion()
        }
    }
    
    var preferredPolicy: LAPolicy {
        biometricType != .none
        ? .deviceOwnerAuthenticationWithBiometrics
        : .deviceOwnerAuthentication
    }

    var biometricType: BiometryType {
        var error: NSError?

        guard canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }

        switch biometryType {
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        case .opticID:
            return .opticID
        @unknown default:
            return .none
        }
    }
}
