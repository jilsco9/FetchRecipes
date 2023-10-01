//
//  AppError.swift
//  FetchRecipes
//
//  Created by Jillian Scott on 9/25/23.
//

import Foundation

protocol AppError: Error {
    var id: String { get }
    var logDescription: String { get }
    var userDescription: String { get }
    var alertDetails: AlertDetails { get }
}

extension AppError {
    var alertDetails: AlertDetails {
        return AlertDetails(id: id, userDescription: userDescription)
    }
}

enum GeneralError: AppError, LocalizedError {
    case unknown(error: Error)
    
    var id: String {
        switch self {
        case .unknown:
            return "GeneralError.unknown"
        }
    }
    
    var logDescription: String {
        switch self {
        case .unknown(let error):
            return "An error occurred: \(id), details: \(error)"
        }
    }
    
    var userDescription: String {
        switch self {
        case .unknown:
            return String(
                localized: "An error occurred",
                comment: "Text for a general or unknown error"
            )
        }
    }
    
    /// Inherited from LocalizedError.errorDescription.
    /// A localized message describing what error occurred
    var errorDescription: String? {
        switch self {
        case .unknown(let error):
            return String(
                localized: "An unknown error occurred: \(error.localizedDescription)",
                comment: "Text for a general or unknown error"
            )
        }
    }
    
    /// Inherited from LocalizedError.failureReason.
    /// A localized message describing the reason for the failure
    var failureReason: String? {
        switch self {
        case .unknown:
            return String(
                localized: "The cause of the error could not be identified",
                comment: "Failure reason for unknown error"
            )
        }
    }
    
    /// Inherited from LocalizedError.helpAnchor.
    /// A localized message providing "help" text if the user requests help
    var helpAnchor: String? {
        switch self {
        case .unknown:
            return String(
                localized: "The app encountered an error it does not know how to handle. Please wait and try again later. If the error does not resolve, please contact customer support.",
                comment: "Help text for unknown error"
            )
        }
    }
    
    /// Inherited from LocalizedError.recoverySuggestion.
    /// A localized message describing how one might recover from the failure
    var recoverySuggestion: String? {
        switch self {
        case .unknown:
            return String(
                localized: "Try again later",
                comment: "Recovery suggestion for unknown error"
            )
        }
    }
}
