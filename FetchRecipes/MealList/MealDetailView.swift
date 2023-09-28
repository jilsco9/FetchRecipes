//
//  MealDetailView.swift
//  FetchRecipes
//
//  Created by Jillian Scott on 9/26/23.
//

import SwiftUI

struct MealDetailView: View {
    var meal: Meal
    @EnvironmentObject private var mealProvider: MealProvider
    @State private var mealDetails: MealDetails? = nil
    @State private var alertDetails: AlertDetails?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                
                Text(meal.name)
                    .font(.largeTitle)
                
                if let mealDetails = self.mealDetails {
                    MealDetailsHeaderStack(mealDetails: mealDetails)
                    
                    Divider()
                        .padding()
                    
                    MealDetailsInstructionsStack(mealDetails: mealDetails)
                    
                    Divider()
                        .padding()
                    
                    MealDetailsMoreInfoStack(mealDetails: mealDetails)
                    
                    Spacer()
                }
            }
            .padding([.leading, .trailing])
        }
        .task {
            if self.mealDetails == nil {
                if let mealDetails = meal.details {
                    self.mealDetails = mealDetails
                } else {
                    do {
                        self.mealDetails = try await mealProvider.getMealDetails(meal: meal)
                    } catch {
                        self.alertDetails = AlertDetails.getAlertDetails(from: error)
                    }
                }
            }
        }
        .alert(item: $alertDetails) { alertDetails in
            alertDetails.alert
        }
    }
}

struct MealDetailsHeaderStack: View {
    let mealDetails: MealDetails
    
    var body: some View {
        VStack {
            TagsView(tags: mealDetails.tags)
            
            OptionalTextView(description: "Category", text: mealDetails.categoryString)
                .font(.headline)
            
            OptionalTextView(description: "Origin", text: mealDetails.areaOfOrigin)
                .font(.headline)
            
            VStack {
                MealImageView(url: mealDetails.thumbnailSource)
                    .frame(width: 200, height: 200)
                
                OptionalTextView(description: "Image Source", text: mealDetails.imageSource?.absoluteString)
                    .font(.caption)
            }
            .padding([.top, .bottom])
            
            OptionalTextView(description: "Drink Alternate", text: mealDetails.drinkAlternate)
            
            ForEach(mealDetails.measurementsAndIngredients, id: \.1) { (measurement, ingredient) in
                HStack {
                    Text(measurement)
                    Spacer()
                    Text(ingredient)
                }
            }
            .padding([.leading, .trailing], 50)
        }
    }
}

struct MealDetailsInstructionsStack: View {
    let mealDetails: MealDetails
    
    var body: some View {
        VStack {
            HStack {
                Text("Instructions:")
                    .font(.title2)
                Spacer()
            }
            .padding([.top, .bottom])
            
            Text(mealDetails.instructions)
        }
    }
}

struct MealDetailsMoreInfoStack: View {
    let mealDetails: MealDetails
    
    var body: some View {
        VStack {
            Text("More information:")
                .font(.title3)
                .padding(4)
            
            OptionalURLView(description: "Recipe source", url: mealDetails.recipeSource)

            OptionalURLView(description: "Watch a video", url: mealDetails.youtubePath)
        }
    }
}

struct OptionalTextView: View {
    let description: String?
    let text: String?
    
    var body: some View {
        if let description = description, let text = text {
            Text("\(description): \(text)")
                .padding(2)
        } else if let text = text {
            Text(text)
                .padding(2)
        }
    }
}

struct OptionalURLView: View {
    let description: String?
    let url: URL?
    
    var body: some View {
        if let description = description, let url = url {
            Link("\(description): \(url.absoluteString)", destination: url)
                .padding(2)
        } else if let url = url {
            Link(url.absoluteString, destination: url)
                .padding(2)
        }
    }
}

struct MealDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MealDetailView(meal: Meal(id: "MealPreviewID", name: "MealPreview Name", thumbnailPath: ""))
            .environmentObject(MealProvider())
    }
}
