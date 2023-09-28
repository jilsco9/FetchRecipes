//
//  Meal.swift
//  FetchRecipes
//
//  Created by Jillian Scott on 9/25/23.
//

import Foundation

struct Meal: Decodable, Identifiable, Hashable {
    let id: String
    let name: String
    let thumbnailPath: String
    var details: MealDetails?
    
    var thumbnailURL: URL? {
        return URL(string: thumbnailPath)?.appending(path: "/preview")
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case thumbnailPath = "strMealThumb"
    }
}
