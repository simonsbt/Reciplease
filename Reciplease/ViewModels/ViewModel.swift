//
//  ViewModel2.swift
//  Reciplease
//
//  Created by Simon Sabatier on 10/11/2023.
//

import Foundation
import SwiftData

@Observable
class ViewModel {
    
    var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchFavoriteRecipes()
    }
    
    var favoriteRecipes: [Recipe] = []
    
    var ingredients: [String] = []
    var ingredientsIsEmpty: Bool = true
    var recipes: [Recipe] = []
    
    var isRefreshing: Bool = true
    var hasBeenFetched: Bool = false
    var hasError: Bool = false
    
    // Fetch favorite recipes from the modelContext
    func fetchFavoriteRecipes() {
        do {
            let descriptor = FetchDescriptor<Recipe>()
            favoriteRecipes = try modelContext.fetch(descriptor)
        } catch {
            print("Fetch failed")
        }
    }
    
    // Async func handling the call of the API
    func getRecipes() async {
        ApiResponse.getRecipes(modelContext: modelContext, ingredients: self.ingredients) { result in
            self.isRefreshing = true
            switch result {
            case .success(let response):
                var recipes: [Recipe] = []
                for recipe in response.hits {
                    recipes.append(try! Recipe(from: recipe.recipe))
                }
                let fetchDescriptor = FetchDescriptor<Recipe>()
                let favRecipes = try! self.modelContext.fetch(fetchDescriptor)
                for recipe in recipes {
                    if let index = favRecipes.firstIndex(where: {$0.title == recipe.title}) {
                        // If the recipe is found in the favRecipes, copy the isFavorite value
                        recipe.isFavorite = favRecipes[index].isFavorite
                    }
                }
                self.recipes = recipes
                self.isRefreshing = false
            case .failure(let error):
                print(error)
                self.hasError = true
                self.isRefreshing = false
            }
        }
    }
    
    // Add a recipe to SwiftData
    func addRecipeToFavorite(recipe: Recipe) {
        if let itemIndex = recipes.firstIndex(where: {$0.title == recipe.title}) {
            recipes[itemIndex].isFavorite = true
        } else {
            print("no corresponding item")
        }
        modelContext.insert(recipe)
        self.fetchFavoriteRecipes()
    }
    
    // Remove a recipe from SwiftData
    func removeRecipeFromFavorite(recipe: Recipe) {
        do {
            if let itemIndex = recipes.firstIndex(where: {$0.title == recipe.title}) {
                recipes[itemIndex].isFavorite = false
            } else {
                print("no corresponding item")
            }
            let fetchDescriptor = FetchDescriptor<Recipe>()
            let favRecipes = try modelContext.fetch(fetchDescriptor) // Get favorite recipes
            
            // get the index of the recipe that needs to be deleted
            if let index = favRecipes.firstIndex(where: {$0.title == recipe.title}) {
                modelContext.delete(favRecipes[index])
            }
            
            self.fetchFavoriteRecipes()
        } catch {
            print("Error while fetching favorite recipes")
        }
    }
    
    // Add an ingredient to the ingredient list
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
    }

    func clearIngredients() {
        self.ingredients = []
        self.ingredientsIsEmpty = true
    }
}
