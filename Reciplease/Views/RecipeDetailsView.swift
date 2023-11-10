//
//  RecipeDetailsView.swift
//  Reciplease
//
//  Created by Simon Sabatier on 07/11/2023.
//

import SwiftUI
import SafariServices
import SwiftData

struct RecipeDetailsView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Binding var viewModel: ViewModel2
    @State var recipe: Recipe
    @State var isFavorite: Bool = false
    
    @Query private var favoriteRecipes: [Recipe]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    AsyncImage(url: URL(string: recipe.imageUrl)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                            .frame(width: 300, height: 300, alignment: .center)
                    }
                    VStack(alignment: .leading) {
                        Text("Ingredients")
                            .font(.title2)
                            .bold()
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(recipe.ingredients, id: \.text) { ingredient in
                                Text("- " + ingredient.text)
                            }
                        }
                        .padding()
                        Button(action: {
                            let vc = SFSafariViewController(url: URL(string: recipe.url)!)
                            UIApplication.shared.firstKeyWindow?.rootViewController?.present(vc, animated: true)
                        }, label: {
                            HStack {
                                Spacer()
                                Text("Get directions")
                                    .foregroundStyle(.white)
                                    .bold()
                                    .padding()
                                Spacer()
                            }
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(14)
                        })
                    }
                    .padding(6)
                }
            }
            .navigationTitle($recipe.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if isFavorite {
                            viewModel.removeRecipeFromFavorite(modelContext: modelContext, recipe: recipe)
                        } else {
                            viewModel.addRecipeToFavorite(modelContext: modelContext, recipe: recipe)
                        }
                        isFavorite.toggle()
                    } label: {
                        Image(systemName: isFavorite ? "star.fill" : "star")
                            .foregroundStyle(.yellow)
                    }
                }
            })
            .onAppear {
                let favRecipe = favoriteRecipes.filter( { $0.title == recipe.title } )
                if favRecipe.isEmpty {
                    isFavorite = false
                } else {
                    isFavorite = true
                }
            }
        }
    }
}

//#Preview {
//    RecipeDetailsView()
//}
