//
//  FavoriteRecipeDetailView.swift
//  Reciplease
//
//  Created by Simon Sabatier on 21/11/2023.
//

import SwiftUI
import SafariServices
import SwiftData
import Algorithms

struct FavoriteRecipeDetailsView: View {
    
    @Binding var viewModel: ViewModel
    @Binding var recipe: Recipe
    
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ZStack(alignment: .topTrailing) {
                        AsyncImage(url: URL(string: recipe.imageUrl)) { phase in
                            if let image = phase.image  {
                                image
                                    .resizable()
                                    .scaledToFit()
                            } else if phase.error != nil {
                                VStack(spacing: 10) {
                                    Image(systemName: "exclamationmark.triangle")
                                        .font(.system(size: 50))
                                    Text("Unable to load the image...")
                                }
                                .frame(width: UIScreen.screenWidth, height: UIScreen.screenWidth)
                                .background(Color(white: 0.95))
                           } else {
                                ProgressView()
                                   .frame(width: UIScreen.screenWidth, height: UIScreen.screenWidth)
                           }
                        }
                        if let duration = recipe.getRecipeDuration() {
                            HStack {
                                Text("Duration: \(duration)")
                                    .foregroundStyle(.black)
                                    .bold()
                                    .padding(.init(top: 6, leading: 10, bottom: 6, trailing: 10))
                            }
                            .background(Color(white: 0.95))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding()
                        }
                    }
                    .frame(width: UIScreen.screenWidth)
                    VStack(alignment: .leading) {
                        Text("Ingredients")
                            .font(.title2)
                            .bold()
                        VStack(alignment: .leading) {
                            ForEach(Array(recipe.ingredientTextList.uniqued()), id: \.self) { ingredientText in
                                Text("- \(ingredientText)")
                            }
                        }
                        .padding()
                        Button(action: {
                            let vc = SFSafariViewController(url: URL(string: (recipe.url))!)
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
                        })
                        .padding(14)
                    }
                    .padding(6)
                }
            }
            .navigationTitle(recipe.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if recipe.isFavorite {
                            showingDeleteAlert = true
                        } else {
                            recipe.isFavorite = true
                            viewModel.addRecipeToFavorite(recipe: recipe)
                        }
                    } label: {
                        Image(systemName: recipe.isFavorite ? "star.fill" : "star")
                            .foregroundStyle(.yellow)
                    }
                    .accessibilityLabel("Remove this recipe from favorites")
                }
            })
            .alert("Remove the recipe from favorites", isPresented: $showingDeleteAlert) {
                Button("Remove", role: .destructive, action: removeRecipeFromFav)
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure?")
            }
        }
        .onDisappear {
            dismiss()
        }
    }
    
    func removeRecipeFromFav() {
        recipe.isFavorite = false
        viewModel.removeRecipeFromFavorite(recipe: recipe)
        dismiss()
    }
}

//#Preview {
//    FavoriteRecipeDetailView()
//}
