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
    @State private var mealDetails: MealDetails?
    @State private var alertDetails: AlertDetails?
    @State private var alertPresented: Bool = false
    
    func fetchMealDetails() async {
        guard mealDetails == nil else { return }
        if let mealDetails = meal.details {
            self.mealDetails = mealDetails
        } else {
            do {
                self.mealDetails = try await mealProvider.getMealDetails(meal: meal)
            } catch {
                self.alertPresented = true
                self.alertDetails = AlertDetails.getAlertDetails(from: error)
            }
        }
    }
    
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
            await fetchMealDetails()
        }
        .alert("Error", isPresented: $alertPresented, presenting: alertDetails, actions: { _ in
            Button("OK") {
                alertDetails = nil
            }
        }, message: { alertDetails in
            Text(alertDetails.userDescription)
        })
    }
}

struct MealDetailsHeaderStack: View {
    let mealDetails: MealDetails
    
    var body: some View {
        VStack {
            TagsView(tags: mealDetails.tags)
            
            OptionalTextView(text: .category(data:  Category.getNameAndLocalizeIfPossible(for: mealDetails.categoryString)))
                .font(.headline)
            
            OptionalTextView(text: .origin(data: mealDetails.areaOfOrigin))
                .font(.headline)
            
            VStack {
                MealImageView(url: mealDetails.thumbnailSource)
                    .frame(width: 200, height: 200)
                
                OptionalTextView(text: .imageSource(data: mealDetails.imageSource?.absoluteString))
                    .font(.caption)
            }
            .padding([.top, .bottom])
            
            OptionalTextView(text: .drinkAlternate(data: mealDetails.drinkAlternate))
            
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
            
            OptionalURLView(text: .recipeSource(data: mealDetails.recipeSource), url: mealDetails.recipeSource)
            
            OptionalURLView(text: .watchAVideo(data: mealDetails.youtubePath), url: mealDetails.youtubePath)
        }
    }
}

struct OptionalTextView: View {
    let text: DetailText
    
    var body: some View {
        if let text = text.dataWithDescription {
            Text(text)
                .padding(2)
        }
    }
}

struct OptionalURLView: View {
    let text: DetailText
    let url: URL?
    
    var body: some View {
        if let url = url,
            let text = text.dataWithDescription {
            Link(text, destination: url)
                .padding(2)
        }
    }
}

struct MealDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MealDetailView(
                meal: Meal(
                    id: "MealPreviewID",
                    name: "MealPreview Name",
                    thumbnailPath: ""
                )
            )
            .environmentObject(MealProvider())
            .environment(\.locale, .init(identifier: "en"))
            
            MealDetailView(
                meal: Meal(
                    id: "MealPreviewID",
                    name: "MealPreview Name",
                    thumbnailPath: ""
                )
            )
            .environmentObject(MealProvider())
            .environment(\.locale, .init(identifier: "fr"))
        }
    }
}
