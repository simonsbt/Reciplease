//
//  FavoriteRecipe.swift
//  Reciplease
//
//  Created by Simon Sabatier on 10/11/2023.
//

import Foundation
import SwiftData

@Model
class Recipe {
   
    var title: String
    var imageUrl: String
    var ingredients: [Ingredient]
    var url: String
    var totalTime: Double
    
    init(title: String, imageUrl: String, ingredients: [Ingredient], url: String, totalTime: Double) {
        self.title = title
        self.imageUrl = imageUrl
        self.ingredients = ingredients
        self.url = url
        self.totalTime = totalTime
    }
}

// A mapping from items in the recipe collection to favorite recipe items.
extension Recipe {
    /// Creates a new FavoriteRecipe instance from a decoded feature.
    convenience init(from recipe: ApiResponse.RecipeObject.RecipeModel) throws {
        self.init(
            title: recipe.label,
            imageUrl: recipe.image,
            ingredients: recipe.ingredients,
            url: recipe.url,
            totalTime: recipe.totalTime
        )
    }
    
    func getRecipeDuration() -> String? {
        if totalTime != 0 {
            let timeMeasure = Measurement(value: totalTime, unit: UnitDuration.minutes)
            let hours = timeMeasure.converted(to: .hours)
            if hours.value >= 1 {
                let minutes = timeMeasure.value.truncatingRemainder(dividingBy: 60)
                if minutes == 0 {
                   return String(format: "%.f%@", hours.value, "h")
                }
                return String(format: "%.f%@%.f", hours.value, "h", minutes)
            }
            return String(format: "%.f%@", timeMeasure.value, "min")
        }
        return nil
    }
    
    func getIngredientList() -> String {
        var ingredientList = ""
        for ingredient in ingredients {
            ingredientList += (ingredient.food.capitalizeFirstLetter + ", ")
        }
        ingredientList.removeLast(2)
        return ingredientList
    }
}
