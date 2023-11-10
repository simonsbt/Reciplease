//
//  ViewModel2.swift
//  Reciplease
//
//  Created by Simon Sabatier on 10/11/2023.
//

import Foundation
import SwiftData

@Observable
class ViewModel2 {
    
    var ingredients: [String] = []
    var ingredientsIsEmpty: Bool = true
    var recipes: [Recipe] = []
    
    func addRecipeToFavorite(modelContext: ModelContext, recipe: Recipe) {
        modelContext.insert(recipe)
    }

    func removeRecipeFromFavorite(modelContext: ModelContext, recipe: Recipe) {
        modelContext.delete(recipe)
    }
            
    func addIngredient(ingredient: String) {
        var ingredient = ingredient
        let letters = NSCharacterSet.letters
        let range = ingredient.rangeOfCharacter(from: letters)
        if let _ = range {
            if ingredient.last == " " {
                ingredient.removeLast()
            }
            ingredients.append(ingredient.capitalizeFirstLetter)
            self.ingredientsIsEmpty = false
        }
        print(ingredients)
    }

    func clearIngredients() {
        self.ingredients = []
        self.ingredientsIsEmpty = true
    }
}
