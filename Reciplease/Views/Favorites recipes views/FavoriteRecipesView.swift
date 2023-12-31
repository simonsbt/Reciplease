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
    @Binding var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            if recipes.isEmpty {
                ContentUnavailableView("You have no favorite recipe !", systemImage: "star.fill", description: Text("Add some in the \"Search\" tab by adding your ingredients !"))
            } else {
                List($viewModel.favoriteRecipes, id: \.url) { $recipe in
                    NavigationLink {
                        FavoriteRecipeDetailsView(viewModel: $viewModel, recipe: $recipe)
                    } label: {
                        RecipeNavigationLinkView(recipe: recipe)
                    }
                }
                .listStyle(.grouped)
                .navigationTitle("Favorite recipes")
                .navigationBarTitleDisplayMode(.large)
            }
        }
        .onAppear {
            viewModel.fetchFavoriteRecipes()
        }
    }
}

//#Preview {
//    FavoriteRecipesView()
//}
