//
//  AlertDetails+Alert.swift
//  FetchRecipes
//
//  Created by Jillian Scott on 9/28/23.
//

import SwiftUI

extension AlertDetails {
    var alert: Alert {
        Alert(
            title: Text(title),
            message: Text(userDescription),
            dismissButton: .cancel(Text(buttonText))
        )
    }
}
