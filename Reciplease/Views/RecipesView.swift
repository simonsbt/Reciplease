//
//  RecipesView.swift
//  Reciplease
//
//  Created by Simon Sabatier on 07/11/2023.
//

import SwiftUI
import SwiftData

struct RecipesView: View {
    
    @Binding var viewModel: ViewModel2
    @Query var recipes: [Recipe]
    @State var presentAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            List(viewModel.recipes, id: \.url) { recipe in
                NavigationLink {
                    RecipeDetailsView(viewModel: $viewModel, recipe: recipe)
                } label: {
                    RecipeNavigationLinkView(recipe: recipe)
                }
            }
            .listStyle(.grouped)
            .navigationTitle("Recipes")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            Task {
                viewModel.recipes = await ApiResponse.getRecipes(ingredients: viewModel.ingredients)
            }
            
//            if !(viewModel.hasBeenFetched) {
//                print("getRecipes")
//                viewModel.getRecipes()
//            }
        }
//        .alert("A problem occured while searching your recipes !", isPresented: $presentAlert) {
//            Button("OK") {
//                viewModel.getRecipes()
//            }
//        }
//        .overlay {
//            if viewModel.isRefreshing {
//                ProgressView()
//            } else if (viewModel.recipes.isEmpty && viewModel.isRefreshing == false) {
//                ContentUnavailableView.search
//            }
//        }
    }
}

//#Preview {
//    RecipesView()
//}
