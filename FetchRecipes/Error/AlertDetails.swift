//
//  AlertDetails.swift
//  FetchRecipes
//
//  Created by Jillian Scott on 9/28/23.
//

import SwiftUI

struct AlertDetails: Identifiable {
    let id: String
    let title: String = "Error"
    let userDescription: String
    let buttonText: String = "OK"
    let isRetryable: Bool = false
    
    static func getAlertDetails(from error: Error) -> AlertDetails {
        return (error as? AppError)?.alertDetails ?? GeneralError.unknown(error: error).alertDetails
    }
}
