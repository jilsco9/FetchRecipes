//
//  Category.swift
//  FetchRecipes
//
//  Created by Jillian Scott on 9/27/23.
//

import Foundation

enum Category: String {
    case dessert = "Dessert"
    // Other categories
    
    var name: String {
        switch self {
        case .dessert:
            return String(
                localized: "Dessert",
                comment: "The name of the dessert category."
            )
        }
    }
    
    static func getNameAndLocalizeIfPossible(for categoryString: String?) -> String? {
        if let categoryString = categoryString, let category = Category(rawValue: categoryString) {
            return category.name
        } else {
            return categoryString
        }
    }
}
