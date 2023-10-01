//
//  MealImageView.swift
//  FetchRecipes
//
//  Created by Jillian Scott on 9/28/23.
//

import SwiftUI

struct MealImageView: View {
    let errorImageName = "fork.knife"
    let noURLImageName = "fork.knife"
    let url: URL?
    
    var body: some View {
        if let thumbnailURL = url {
            AsyncImage(url: thumbnailURL) { phase in
                if let image = phase.image {
                    image.resizable()
                } else if phase.error != nil {
                    Image(systemName: errorImageName)
                        .resizable()
                        .padding()
                        .opacity(0.5)
                } else {
                    ProgressView()
                }
            }
        } else {
            Image(systemName: noURLImageName)
                .resizable()
                .padding()
                .opacity(0.5)
        }
    }
}
