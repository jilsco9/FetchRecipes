//
//  MealProvider.swift
//  FetchRecipes
//
//  Created by Jillian Scott on 9/25/23.
//

import Foundation

@MainActor
class MealProvider: ObservableObject {
    let mealClient: MealClient
    
    @Published var meals: [Meal] = []
    
    init(mealClient: MealClient = MealClient()) {
        self.mealClient = mealClient
    }
    
    func getMealsForCategory(_ category: Category) async throws {
        let meals = try await mealClient.getMeals(category: category.rawValue)
        
        // It looks like the API is already returning these sorted
        // If we can rely on the API doing so, we don't need to below
        // code, but I have included it in comments in case we cannot
        // expect the API to always deliver the content alphabetically.
        // This is something I would discuss when refining AC
        
//        self.meals = meals.sorted {
//            return $0.name < $1.name
//        }
        
        self.meals = meals
    }
    
    func getMealDetails(meal: Meal) async throws -> MealDetails {
        let mealDetails = try await mealClient.getMealDetails(id: meal.id)
        if let mealIndex = meals.firstIndex(where: { $0.id == mealDetails.id }) {
            meals[mealIndex].details = mealDetails
        }
        return mealDetails
    }
}
