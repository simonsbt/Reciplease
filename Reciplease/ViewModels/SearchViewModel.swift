//
//  SearchViewModel.swift
//  Reciplease
//
//  Created by Simon Sabatier on 07/11/2023.
//

import Foundation

@MainActor class SearchViewModel: ObservableObject {
    
    @Published var ingredients: [String] = []
    
    private var recipeObjects: [RecipeObject] = []
    @Published var recipes: [Recipe] = []
    
    private var type = "public"
    
    func getRecipes() {
        var ingredientsQuery = ""
        for ingredient in ingredients {
            ingredientsQuery += (ingredient + " ")
        }
    }
    
    func addIngredient(ingredient: String) {
        var ingredient = ingredient
        let letters = NSCharacterSet.letters
        let range = ingredient.rangeOfCharacter(from: letters)
        if let _ = range {
            if ingredient.last == " " {
                ingredient.removeLast()
            }
            self.ingredients.append(ingredient.capitalizeFirstLetter)
        }
    }
    
    func clearIngredients() {
        self.ingredients = []
    }
}
