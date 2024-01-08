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
            AsyncImage(url: URL(string: recipe.imageUrl)) { phase in
                if let image = phase.image  {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 3)
                } else if phase.error != nil {
                    VStack(spacing: 10) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 20))
                    }
                    .frame(width: 80, height: 80)
                    .background(Color(white: 0.95))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
               } else {
                    ProgressView()
                       .frame(width: 80, height: 80)
                }
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
                Text(recipe.getIngredientFoodStringList())
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                    .lineLimit(1)
                    .accessibilityHint("Ingredients list")
            }
        }
    }
}

//#Preview {
//    RecipeNavigationLinkView()
//}
