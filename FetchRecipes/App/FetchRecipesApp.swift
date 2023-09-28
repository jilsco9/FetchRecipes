//
//  FetchRecipesApp.swift
//  FetchRecipes
//
//  Created by Jillian Scott on 9/24/23.
//

import SwiftUI

@main
struct FetchRecipesApp: App {
    @StateObject var mealProvider = MealProvider()
    
    var body: some Scene {
        WindowGroup {
            MealListView()
                .environmentObject(mealProvider)
        }
    }
}
