//
//  MealListView.swift
//  FetchRecipes
//
//  Created by Jillian Scott on 9/24/23.
//

import SwiftUI

struct MealListView: View {
    @EnvironmentObject var mealProvider: MealProvider
    @State private var alertDetails: AlertDetails?
    @State private var alertPresented: Bool = false
    let category = Category.dessert
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(mealProvider.meals) { meal in
                    NavigationLink {
                        MealDetailView(meal: meal)
                    } label: {
                        MealListItemView(meal: meal)
                    }
                }
            }
            .listStyle(.inset)
            .navigationTitle("Category: \(category.name)")
            .refreshable {
                do {
                    try await mealProvider.getMealsForCategory(category)
                } catch {
                    self.alertDetails = AlertDetails.getAlertDetails(from: error)
                }
            }
        }
        .task {
            do {
                try await mealProvider.getMealsForCategory(category)
            } catch {
                self.alertDetails = AlertDetails.getAlertDetails(from: error)
            }
        }
        .alert("Error", isPresented: $alertPresented, presenting: alertDetails, actions: { _ in
            Button("OK") {
                
            }
        }, message: { alertDetails in
            Text(alertDetails.userDescription)
        })
    }
}

struct MealListItemView: View {
    let meal: Meal
    
    var body: some View {
        HStack {
            MealImageView(url: meal.thumbnailURL)
                .frame(width: 50, height: 50)
            Text(meal.name)
        }
    }
}

struct MealListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MealListView()
                .environmentObject(MealProvider())
                .environment(\.locale, .init(identifier: "en"))
            MealListView()
                .environmentObject(MealProvider())
                .environment(\.locale, .init(identifier: "fr"))
        }
    }
}
