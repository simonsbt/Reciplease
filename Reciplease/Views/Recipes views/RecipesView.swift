//
//  RecipesView.swift
//  Reciplease
//
//  Created by Simon Sabatier on 07/11/2023.
//

import SwiftUI
import SwiftData

struct RecipesView: View {
    
    @Binding var viewModel: ViewModel
    @State var presentAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            List(viewModel.recipes, id: \.url) { recipe in
                // Get the index in viewModel of the actual recipe
                if let index = viewModel.recipes.firstIndex(where: { $0.title == recipe.title } ) {
                    NavigationLink {
                        RecipeDetailsView(viewModel: $viewModel, index: index)
                    } label: {
                        RecipeNavigationLinkView(recipe: recipe)
                    }
                }
            }
            .listStyle(.grouped)
            .navigationTitle("Recipes")
            .navigationBarTitleDisplayMode(.large)
        }
        .task {  
            if viewModel.hasBeenFetched == false {
                await fetchRecipes()
                viewModel.hasBeenFetched = true
            }
        }
        .refreshable {
            await viewModel.getRecipes()
        }
        .alert("A problem occured while searching your recipes !", isPresented: $viewModel.hasError) {
            Button("Cancel", role: .cancel) { }
            Button("Retry") {
                Task {
                    await fetchRecipes()
                }
            }
        }
        .overlay {
            if viewModel.isRefreshing {
                ProgressView()
            } else if (viewModel.recipes.isEmpty) {
                ContentUnavailableView.search
            }
        }
    }
    
    func fetchRecipes() async {
        viewModel.isRefreshing = true
        viewModel.recipes = []
        await viewModel.getRecipes()
    }
}

//#Preview {
//    RecipesView()
//}
