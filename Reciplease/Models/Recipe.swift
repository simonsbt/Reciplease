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
    var ingredientFoodList: [String]
    var ingredientTextList: [String]
    var url: String
    var totalTime: Double
    var isFavorite: Bool
    
    init(title: String, imageUrl: String, ingredientFoodList: [String], ingredientTextList: [String], url: String, totalTime: Double) {
        self.title = title
        self.imageUrl = imageUrl
        self.ingredientFoodList = ingredientFoodList
        self.ingredientTextList = ingredientTextList
        self.url = url
        self.totalTime = totalTime
        self.isFavorite = false
    }
}

// A mapping from items in the recipe collection to favorite recipe items.
extension Recipe {
    /// Creates a new FavoriteRecipe instance from a decoded feature.
    convenience init(from recipe: ApiResponse.RecipeObject.RecipeModel) throws {
        self.init(
            title: recipe.label,
            imageUrl: recipe.image,
            ingredientFoodList: recipe.getIngredientFoodList(),
            ingredientTextList: recipe.getIngredientTextList(),
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
                } else if minutes < 10 {
                    return String(format: "%.f%@0%.f", hours.value, "h", minutes)
                }
                return String(format: "%.f%@%.f", hours.value, "h", minutes)
            }
            return String(format: "%.f%@", timeMeasure.value, "min")
        }
        return nil
    }
    
    /// Reports the total number of recipes.
    static func totalRecipes(modelContext: ModelContext) -> Int {
        (try? modelContext.fetchCount(FetchDescriptor<Recipe>())) ?? 0
    }
    
    func getIngredientFoodStringList() -> String {
        var list = ""
        for ingredient in ingredientFoodList {
            list += (ingredient.capitalizeFirstLetter + ", ")
        }
        list.removeLast(2)
        return list
    }
}
