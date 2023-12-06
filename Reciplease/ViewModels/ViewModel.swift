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
    
    var selectedSortOrder = "Forward"
    var selectedSortOption = "Title"
    let sortOrder: [String] = ["Forward", "Reverse"]
    let sortOptions: [String] = ["Duration", "Name"]
    
    var isRefreshing: Bool = true
    var hasBeenFetched: Bool = false
    
    func fetchFavoriteRecipes() {
        do {
            let descriptor = FetchDescriptor<Recipe>()
            favoriteRecipes = try modelContext.fetch(descriptor)
        } catch {
            print("Fetch failed")
        }
    }
    
    func addRecipeToFavorite(recipe: Recipe) {
        if let itemIndex = recipes.firstIndex(where: {$0.title == recipe.title}) {
            recipes[itemIndex].isFavorite = true
            print("\(recipes[itemIndex].title) favorite set to \(recipes[itemIndex].isFavorite)")
        } else {
            print("no corresponding item")
        }
        modelContext.insert(recipe)
        self.fetchFavoriteRecipes()
    }
    
//    func addRecipeToFavorite(recipe: Recipe) {
//        if let itemIndex = recipes.firstIndex(where: {$0.title == recipe.title}) {
//            recipes[itemIndex].isFavorite = true
//            print("\(recipes[itemIndex].title) favorite set to \(recipes[itemIndex].isFavorite)")
//        } else {
//            print("no corresponding item")
//        }
//        print("There is \(Recipe.totalRecipes(modelContext: modelContext)) fav recipes before addition")
//        modelContext.insert(recipe)
//        print("There is \(Recipe.totalRecipes(modelContext: modelContext)) fav recipes after addition")
//        try? modelContext.save()
//        print("There is \(Recipe.totalRecipes(modelContext: modelContext)) fav recipes after save")
//    }
    
    func getRecipes() async {
        
        await recipes = ApiResponse.getRecipes(modelContext: modelContext, ingredients: self.ingredients)
    }

//    func removeRecipeFromFavorite(recipe: Recipe) {
//        if let itemIndex = recipes.firstIndex(where: {$0.title == recipe.title}) {
//            recipes[itemIndex].isFavorite = false
//            print("\(recipes[itemIndex].title) favorite set to \(recipes[itemIndex].isFavorite)")
//            modelContext.delete(recipes[itemIndex])
//            print("\(recipes[itemIndex].title) removed")
//        } else {
//            print("no corresponding item")
//        }
//        
//        self.fetchFavoriteRecipes()
//    }
    
    func removeRecipeFromFavorite(recipe: Recipe) {
        if let itemIndex = recipes.firstIndex(where: {$0.title == recipe.title}) {
            recipes[itemIndex].isFavorite = false
            print("\(recipes[itemIndex].title) favorite set to \(recipes[itemIndex].isFavorite)")
        } else {
            print("no corresponding item")
        }
        let fetchDescriptor = FetchDescriptor<Recipe>()
        let favRecipes = try! modelContext.fetch(fetchDescriptor)
        var recipeToDelete: Recipe
        if let index = favRecipes.firstIndex(where: {$0.title == recipe.title}) {
            print("recipe \(recipe.title) found in favRecipes at index \(index)")
            recipeToDelete = favRecipes[index]
            print("There is \(Recipe.totalRecipes(modelContext: modelContext)) fav recipes before deletion")
            modelContext.delete(recipeToDelete)
            print("There is \(Recipe.totalRecipes(modelContext: modelContext)) fav recipes after deletion")
            try? modelContext.save()
            print("There is \(Recipe.totalRecipes(modelContext: modelContext)) fav recipes after save")
        }
        self.fetchFavoriteRecipes()
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
