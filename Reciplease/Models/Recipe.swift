//
//  Recipe.swift
//  Reciplease
//
//  Created by Simon Sabatier on 07/11/2023.
//

import Foundation
import SwiftData

@Model
class Recipes {
    var count: Int
    var hits: [Recipe]
    
    init(count: Int, hits: [Recipe]) {
        self.count = count
        self.hits = hits
    }
}

@Model
class RecipeObject {
    var recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
}

@Model
class Recipe {
    var label: String
    var image: String
    var ingredients: [Ingredient]
    var totalTime: Double
    
    init(label: String, image: String, ingredients: [Ingredient], totalTime: Double) {
        self.label = label
        self.image = image
        self.ingredients = ingredients
        self.totalTime = totalTime
    }
}

@Model
class Ingredient {
    var text: String
    var food: String
    
    init(text: String, food: String) {
        self.text = text
        self.food = food
    }
}
