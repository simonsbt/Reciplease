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
    
    @Binding var viewModel: ViewModel
    let index: Int // Used to get the recipes from the viewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ZStack(alignment: .topTrailing) {
                        AsyncImage(url: URL(string: viewModel.recipes[index].imageUrl)) { phase in
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
                        if let duration = viewModel.recipes[index].getRecipeDuration() {
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
                            ForEach(Array(viewModel.recipes[index].ingredientTextList.uniqued()), id: \.self) { ingredientText in
                                Text("- \(ingredientText)")
                            }
                        }
                        .padding()
                        Button(action: {
                            let vc = SFSafariViewController(url: URL(string: (viewModel.recipes[index].url))!)
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
            .navigationTitle(viewModel.recipes[index].title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if viewModel.recipes[index].isFavorite {
                            viewModel.recipes[index].isFavorite = false
                            viewModel.removeRecipeFromFavorite(recipe: viewModel.recipes[index])
                        } else {
                            viewModel.recipes[index].isFavorite = true
                            viewModel.addRecipeToFavorite(recipe: viewModel.recipes[index])
                        }
                    } label: {
                        Image(systemName: viewModel.recipes[index].isFavorite ? "star.fill" : "star")
                            .foregroundStyle(.yellow)
                    }
                    .accessibilityLabel(viewModel.recipes[index].isFavorite ? "Remove this recipe from favorites" : "Add this recipe to favorites")
                }
            })
        }
    }
}

//#Preview {
//    RecipeDetailsView()
//}
