//
//  RecipleaseTests.swift
//  RecipleaseTests
//
//  Created by simon on 08/01/2024.
//

import XCTest
import Alamofire
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
}
