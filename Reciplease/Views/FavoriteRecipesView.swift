//
//  FavoriteRecipesView.swift
//  Reciplease
//
//  Created by Simon Sabatier on 08/11/2023.
//

import SwiftUI
import SwiftData

struct FavoriteRecipesView: View {
    
    @Query var recipes: [Recipe]
    @Binding var viewModel: ViewModel2
    
    var body: some View {
        NavigationStack {
            if recipes.isEmpty {
                ContentUnavailableView("You have no favorite recipe !", systemImage: "star.fill", description: Text("Add some favorite recipes with this few steps: go in the \"Search\" tab, enter your ingredients, select a recipe that you like and tap the star at the top-left of the screen !"))
            } else {
                List(recipes, id: \.self) { recipe in
                    NavigationLink {
                        RecipeDetailsView(viewModel: $viewModel, recipe: recipe)
                    } label: {
                        RecipeNavigationLinkView(recipe: recipe)
                    }
                }
                .listStyle(.grouped)
                .navigationTitle("Favorite recipes")
                .navigationBarTitleDisplayMode(.large)
            }
        }
    }
}

//#Preview {
//    FavoriteRecipesView()
//}
