//
//  MealDetails.swift
//  FetchRecipes
//
//  Created by Jillian Scott on 9/24/23.
//

import Foundation

struct MealDetails: Decodable, Identifiable, Hashable {
    let id: String
    let name: String
    let drinkAlternate: String?
    let categoryString: String
    let areaOfOrigin: String?
    let instructions: String
    let thumbnailSource: URL?
    let tags: [String]?
    let youtubePath: URL?
    let measurementsAndIngredients: [(String, String)]
    let recipeSource: URL?
    let imageSource: URL?
    let creativeCommonsConfirmed: String?
    let dateModifiedString: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case drinkAlternate = "strDrinkAlternate"
        case categoryString = "strCategory"
        case areaOfOrigin = "strArea"
        case instructions = "strInstructions"
        case thumbnailSource = "strMealThumb"
        case tags = "strTags"
        case youtubePath = "strYoutube"
        case recipeSource = "strSource"
        case imageSource = "strImageSource"
        case creativeCommonsConfirmed = "strCreativeCommonsConfirmed"
        case dateModifiedString = "dateModified"
        case strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5, strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10, strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15, strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20
        case strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5, strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10, strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15, strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        measurementsAndIngredients = try (1...20).compactMap { index in
            if let measurementCodingKey = CodingKeys(rawValue: "strMeasure\(index)"),
               let ingredientCodingKey = CodingKeys(rawValue: "strIngredient\(index)"),
               let measurement = try container.decodeIfPresent(String.self,
                                                               forKey: measurementCodingKey),
               let ingredient = try container.decodeIfPresent(String.self,
                                                              forKey: ingredientCodingKey),
               !measurement.isEmpty,
               !ingredient.isEmpty
            {
                return (measurement, ingredient)
            } else {
                return nil
            }
        }.removingDuplicateIngredients()
                
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        drinkAlternate = try container.decodeIfPresent(String.self, forKey: .drinkAlternate)
        categoryString = try container.decode(String.self, forKey: .categoryString)
        areaOfOrigin = try container.decodeIfPresent(String.self, forKey: .areaOfOrigin)
        
        if let thumbnailString = try container.decodeIfPresent(String.self, forKey: .thumbnailSource) {
            thumbnailSource = URL(string: thumbnailString)
        } else {
            thumbnailSource = nil
        }
        
        if let multiTagsString = try container.decodeIfPresent(String.self, forKey: .tags) {
            tags = multiTagsString.components(separatedBy: ",")
        } else {
            tags = nil
        }
        
        if let youtubePathString = try container.decodeIfPresent(String.self, forKey: .youtubePath) {
            youtubePath = URL(string: youtubePathString)
        } else {
            youtubePath = nil
        }
        
        if let recipeSourceString = try container.decodeIfPresent(String.self, forKey: .recipeSource) {
            recipeSource = URL(string: recipeSourceString)
        } else {
            recipeSource = nil
        }
        
        if let imageSourceString = try container.decodeIfPresent(String.self, forKey: .imageSource) {
            imageSource = URL(string: imageSourceString)
        } else {
            imageSource = nil
        }
        
        creativeCommonsConfirmed = try container.decodeIfPresent(String.self, forKey: .creativeCommonsConfirmed)
        dateModifiedString = try container.decodeIfPresent(String.self, forKey: .dateModifiedString)
        instructions = try container.decode(String.self, forKey: .instructions).replacingOccurrences(of: "\r\n", with: "\n\n")
    }
    
    static func == (lhs: MealDetails, rhs: MealDetails) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// Easily remove duplicates from an array of (String, String)
// We may prefer to keep both in the case where the API returns
// returns two identical ingredients with different measurements,
// and we don't know which is valid. But for now, we will assume the
// first one we encounter is the one we want.
fileprivate extension Array where Element == (String, String) {
    func removingDuplicateIngredients() -> [Element] {
        var addedDict = [String: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0.1) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicateIngredients()
    }
}
