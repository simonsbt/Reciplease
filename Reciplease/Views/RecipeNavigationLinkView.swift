//
//  RecipeNavigationLinkView.swift
//  Reciplease
//
//  Created by Simon Sabatier on 07/11/2023.
//

import SwiftUI

struct RecipeNavigationLinkView: View {
    
    @State var recipe: Recipe
    
    var body: some View {
        HStack(spacing: 10) {
            AsyncImage(url: URL(string: recipe.imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 3)
            } placeholder: {
                ProgressView()
            }
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(recipe.title)
                        .bold()
                        .lineLimit(2)
                    Spacer()
                    if let duration = recipe.getRecipeDuration() {
                        Text(duration)
                    }
                }
                Text(recipe.getIngredientList())
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .truncationMode(.tail)
                    .lineLimit(1)
            }
        }
    }
}

//#Preview {
//    RecipeNavigationLinkView()
//}
