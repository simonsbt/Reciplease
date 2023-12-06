//
//  Recipe.swift
//  Reciplease
//
//  Created by Simon Sabatier on 07/11/2023.
//

import Foundation
import SwiftData
import SwiftUI

struct ApiResponse: Decodable {
    let count: Int
    let hits: [RecipeObject]
    
    struct RecipeObject: Decodable {
        let recipe: RecipeModel
        
        struct RecipeModel: Decodable {
            let label: String
            let image: String
            let ingredients: [Ingredient]
            let url: String
            let totalTime: Double
            
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
            
            func getIngredientTextList() -> [String] {
                var list: [String] = []
                for ingredient in ingredients {
                    list.append(ingredient.text)
                }
                return list
            }
            
            func getIngredientFoodList() -> [String] {
                var list: [String] = []
                for ingredient in ingredients {
                    list.append(ingredient.food)
                }
                return list
            }
        }
    }
}

extension ApiResponse {
    
    static private func fetchRecipes(ingredients: [String]) async throws -> ApiResponse {
        let type = "&type=public"
        let endpoint = "https://api.edamam.com/api/recipes/v2?"
        let appId = getAppAuth(auth: .app_id)
        let appKey = getAppAuth(auth: .app_key)
        
        var ingredientsQuery = ""
        for ingredient in ingredients {
            ingredientsQuery += (ingredient + ",")
        }
        print(ingredientsQuery)
        guard let url = URL(string: endpoint + type + appId + appKey + "&q=" + ingredientsQuery) else {
            throw FetchError.incorrectUrl
        }

        let session = URLSession.shared
        guard let (data, response) = try? await session.data(from: url),
              let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
            throw FetchError.missingData
        }

        do {
            // Decode the JSON into a data model.
            let jsonDecoder = JSONDecoder()
            return try jsonDecoder.decode(ApiResponse.self, from: data)
        } catch {
            throw FetchError.wrongDataFormat(error: error)
        }
    }
    
    static func getRecipes(modelContext: ModelContext, ingredients: [String]) async -> [Recipe] {
        do {
            var recipes: [Recipe] = []
            let response = try await fetchRecipes(ingredients: ingredients)
            for recipe in response.hits {
                recipes.append(try Recipe(from: recipe.recipe))
            }
            let fetchDescriptor = FetchDescriptor<Recipe>()
            let favRecipes = try modelContext.fetch(fetchDescriptor)
            for favRecipe in favRecipes {
                print(favRecipe.title)
            }
            for recipe in recipes {
                if let index = favRecipes.firstIndex(where: {$0.title == recipe.title}) {
                    print("recipe \(recipe.title) found in favRecipes at index \(index)")
                    recipe.isFavorite = favRecipes[index].isFavorite
                } else {
                    print("recipe not found")
                }
            }
            return recipes
        } catch {
            print(error)
            return []
        }
    }
    
    static func getAppAuth(auth: AppAuth) -> String {
        guard let filePath = Bundle.main.path(forResource: "config", ofType: "plist") else {
            fatalError("Couldn't find file 'config.plist'.")
        }
        
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: auth.rawValue) as? String else {
            fatalError("Couldn't find key \(auth.rawValue) in 'config.plist'.")
        }
        return value
    }
}

struct Ingredient: Codable {
    let text: String
    let food: String
    let foodId: String
}

enum AppAuth: String {
    case app_id, app_key
}

enum FetchError: Error {
    case wrongDataFormat(error: Error)
    case missingData
    case incorrectUrl
}
