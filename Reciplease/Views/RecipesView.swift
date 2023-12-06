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
            List($viewModel.recipes, id: \.url) { $recipe in
                if let index = viewModel.recipes.firstIndex(where: { $0.title == recipe.title } ) {
                    NavigationLink {
                        RecipeDetailsView(viewModel: $viewModel, /*recipe: $recipe,*/ index: index)
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
        .alert("A problem occured while searching your recipes !", isPresented: $presentAlert) {
            Button("OK") {
                Task {
                    await fetchRecipes()
                }
            }
        }
        .overlay {
            if viewModel.isRefreshing {
                ProgressView()
            } else if (viewModel.recipes.isEmpty && viewModel.isRefreshing == false) {
                ContentUnavailableView.search
            }
        }
    }
    
    func fetchRecipes() async {
        viewModel.isRefreshing = true
        viewModel.recipes = []
        await viewModel.getRecipes()
        viewModel.isRefreshing = false
    }
}

//#Preview {
//    RecipesView()
//}
