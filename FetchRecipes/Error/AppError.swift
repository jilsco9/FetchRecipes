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

enum GeneralError: AppError {
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
            return "An error occurred"
        }
    }
}
