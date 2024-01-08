//
//  RecipleaseTests.swift
//  RecipleaseTests
//
//  Created by simon on 08/01/2024.
//

import XCTest
@testable import Reciplease
import SwiftData

@MainActor
final class RecipleaseTests: XCTestCase {
    
    func testAppStartsEmpty() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Recipe.self, configurations: config)

        let vm = ViewModel(modelContext: container.mainContext)

        XCTAssertEqual(vm.favoriteRecipes.count, 0, "There should be 0 favorite recipes when the app is first launched.")
    }
    
    func testCreatingRecipe() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Recipe.self, configurations: config)

        let vm = ViewModel(modelContext: container.mainContext)
        vm.recipes.append(Recipe(title: "Test recipe", imageUrl: "", ingredientFoodList: [], ingredientTextList: [], url: "", totalTime: 3600))
        vm.addRecipeToFavorite(recipe: vm.recipes[0])

        XCTAssertEqual(vm.favoriteRecipes.count, 1, "There should be 1 favorite recipe after adding sample data.")
    }
    
    func testGetFavoritesRecipeCount() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Recipe.self, configurations: config)

        let vm = ViewModel(modelContext: container.mainContext)
        vm.recipes.append(Recipe(title: "Test recipe", imageUrl: "", ingredientFoodList: [], ingredientTextList: [], url: "", totalTime: 3600))
        vm.recipes.append(Recipe(title: "Test recipe2", imageUrl: "", ingredientFoodList: [], ingredientTextList: [], url: "", totalTime: 7200))
        vm.addRecipeToFavorite(recipe: vm.recipes[0])
        vm.addRecipeToFavorite(recipe: vm.recipes[1])
        

        XCTAssertEqual(Recipe.totalRecipes(modelContext: container.mainContext), 2, "There should be 2 favorite recipe after adding sample data.")
    }
    
    func testDeletingRecipe() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Recipe.self, configurations: config)

        let vm = ViewModel(modelContext: container.mainContext)
        vm.recipes.append(Recipe(title: "Test recipe", imageUrl: "", ingredientFoodList: [], ingredientTextList: [], url: "", totalTime: 3600))
        vm.addRecipeToFavorite(recipe: vm.recipes[0])

        vm.removeRecipeFromFavorite(recipe: vm.recipes[0])
        XCTAssertEqual(vm.favoriteRecipes.count, 0, "There should be 0 favorite recipe after deleting data.")
    }
    
    func testAddingIngredients() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Recipe.self, configurations: config)

        let vm = ViewModel(modelContext: container.mainContext)
        vm.addIngredient(ingredient: "")
        vm.addIngredient(ingredient: "@@@@")
        vm.addIngredient(ingredient: "Chicken")

        XCTAssertEqual(vm.ingredients.count, 1, "There should be 1 ingredient after adding sample data.")
    }
    
    func testClearingIngredients() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Recipe.self, configurations: config)

        let vm = ViewModel(modelContext: container.mainContext)
        vm.addIngredient(ingredient: "Chicken")
        vm.addIngredient(ingredient: "Strawberry")
        vm.addIngredient(ingredient: "Apple")
        vm.clearIngredients()

        XCTAssertEqual(vm.ingredients.count, 0, "There should be 0 ingredient after clearing.")
    }
    
    func testGetRecipeDuration() throws {
        let recipe = Recipe(title: "", imageUrl: "", ingredientFoodList: [], ingredientTextList: [], url: "", totalTime: 60)
        
        let duration = recipe.getRecipeDuration()
        
        XCTAssertEqual(duration, "1:00:00", "Duration should be equal to 1 hour")
    }
    
    func testGetIngredientTextList() throws {
        
        let ingredient1 = Ingredient(text: "Pinch of pepper", food: "", foodId: "")
        let ingredient2 = Ingredient(text: "Pinch of salt", food: "", foodId: "")
        let ingredient3 = Ingredient(text: "Chicken breast", food: "", foodId: "")
        
        let recipeModel = ApiResponse.RecipeObject.RecipeModel(label: "", image: "", ingredients: [ingredient1, ingredient2, ingredient3], url: "", totalTime: 0)
        
        let ingredientTextList = recipeModel.getIngredientTextList()
        let ingredientTextListExpected = ["Pinch of pepper", "Pinch of salt", "Chicken breast"]
        
        XCTAssertEqual(ingredientTextList, ingredientTextListExpected, "Lists should be equal")
    }
    
    func testGetIngredientList() throws {
        
        let ingredient1 = Ingredient(text: "", food: "Pepper", foodId: "")
        let ingredient2 = Ingredient(text: "", food: "Salt", foodId: "")
        let ingredient3 = Ingredient(text: "", food: "Chicken", foodId: "")
        
        let recipeModel = ApiResponse.RecipeObject.RecipeModel(label: "", image: "", ingredients: [ingredient1, ingredient2, ingredient3], url: "", totalTime: 0)
        
        let ingredientFoodList = recipeModel.getIngredientFoodList()
        let ingredientFoodListExpected = ["Pepper", "Salt", "Chicken"]
        
        XCTAssertEqual(ingredientFoodList, ingredientFoodListExpected, "Lists should be equal")
    }
    
    func testGetRecipeIngredientList() throws {
        
        let recipe = Recipe(title: "", imageUrl: "", ingredientFoodList: ["Chicken", "Pepper", "Salt"], ingredientTextList: [], url: "", totalTime: 0)
        
        let ingredientFoodList = recipe.getIngredientFoodStringList()
        let ingredientFoodListExpected = "Chicken, Pepper, Salt"
        
        XCTAssertEqual(ingredientFoodList, ingredientFoodListExpected, "Lists should be equal")
    }
    
    func testGetRecipesFromAPI() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Recipe.self, configurations: config)
        
        let expectations = expectation(description: "The Response result match the expected results")
        
        ApiResponse.getRecipes(modelContext: container.mainContext, ingredients: ["Chicken"]) { result in
            switch(result) {
            case .success(_):
                expectations.fulfill()
            case .failure(let error):
                XCTFail("Server response failed : \(error.localizedDescription)")
                expectations.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10, handler: { (error) in
            if let error = error {
                print("Failed : \(error.localizedDescription)")
            }
        })
    }
}
