//
//  MealDetailText.swift
//  FetchRecipes
//
//  Created by Jillian Scott on 10/1/23.
//

import Foundation

enum DetailText {
    case category(data: String?)
    case origin(data: String?)
    case drinkAlternate(data: String?)
    case imageSource(data: String?)
    case recipeSource(data: URL?)
    case watchAVideo(data: URL?)
    
    var dataWithDescription: String? {
        switch self {
        case .category(let data):
            if let data = data {
                return String(
                    localized: "Category: \(data)",
                    comment: "A meal's category data with description"
                )
            }
        case .origin(let data):
            if let data = data {
                return String(
                    localized: "Origin: \(data)",
                    comment: "A meal's category data with description"
                )
            }
        case .drinkAlternate(let data):
            if let data = data {
                return String(
                    localized: "Drink alternate: \(data)",
                    comment: "A meal's drink alternate data with description"
                )
            }
        case .imageSource(let data):
            if let data = data {
                return String(
                    localized: "Image source: \(data)",
                    comment: "A meal's image source data with description"
                )
            }
        case .recipeSource(let data):
            if let data = data {
                return String(
                    localized: "Recipe source: \(data.absoluteString)",
                    comment: "A meal's recipe source data with description"
                )
            }
        case .watchAVideo(let data):
            if let data = data {
                return String(
                    localized: "Watch a video: \(data.absoluteString)",
                    comment: "A meal's video source data with description"
                )
            }
        }
        return nil
    }
}
