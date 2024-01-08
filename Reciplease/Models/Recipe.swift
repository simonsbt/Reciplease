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
    
    /// Return the duration of a recipe
    func getRecipeDuration() -> String? {
        var duration: Duration
        if totalTime != 0 {
            let timeMeasure = Measurement(value: totalTime, unit: UnitDuration.minutes)
            let hours = timeMeasure.converted(to: .hours)
            duration = Duration.seconds(hours.value * 60 * 60)
            return duration.formatted()
        }
        return nil
    }
    
    /// Reports the total number of recipes.
    static func totalRecipes(modelContext: ModelContext) -> Int {
        (try? modelContext.fetchCount(FetchDescriptor<Recipe>())) ?? 0
    }
    
    /// Return the ingredients
    func getIngredientFoodStringList() -> String {
        var list = ""
        for ingredient in ingredientFoodList {
            list += (ingredient.capitalizeFirstLetter + ", ")
        }
        list.removeLast(2)
        return list
    }
}
