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
    var count: Int
    var hits: [RecipeObject]
    
    struct RecipeObject: Decodable {
        var recipe: RecipeModel
        
        struct RecipeModel: Decodable {
            var label: String
            var image: String
            var ingredients: [Ingredient]
            var url: String
            var totalTime: Double
            
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
    
    static func getRecipes(ingredients: [String]) async -> [Recipe] {
        do {
            var recipes: [Recipe] = []
            let response = try await fetchRecipes(ingredients: ingredients)
            for recipe in response.hits {
                recipes.append(try Recipe(from: recipe.recipe))
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
    var text: String
    var food: String
    var foodId: String
}

enum AppAuth: String {
    case app_id, app_key
}

enum FetchError: Error {
    case wrongDataFormat(error: Error)
    case missingData
    case incorrectUrl
}
//
//
//struct ApiResponse: Decodable {
//    var count: Int
//    var hits: [RecipeObject]
//    
//    struct RecipeObject: Decodable {
//        var recipe: Recipe
//        
//        struct Recipe: Decodable {
//            var label: String
//            var image: String?
//            var ingredients: [Ingredient]
//            var url: String
//            var totalTime: Double
//        }
//    }
//}
//
//extension ApiResponse.RecipeObject.Recipe {
//    func getImageURL(size: String) -> URL {
//        var tempUrl = ""
//        switch(size) {
//        case "THUMBNAIL":
//            tempUrl = images.THUMBNAIL.url
//        case "SMALL":
//            tempUrl = images.SMALL.url
//        case "REGULAR":
//            tempUrl = images.REGULAR.url
//        default:
//            tempUrl = images.REGULAR.url
//        }
//        if let url = URL(string: tempUrl) {
//            return url
//        }
//        return URL(string: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fcraftsnippets.com%2Farticles%2Fplaceholder-image-macro-for-craft-cms&psig=AOvVaw0-Tw0sF4L8yF4dC-5vbauS&ust=1699526373851000&source=images&cd=vfe&ved=0CBEQjRxqFwoTCPjKyKKbtIIDFQAAAAAdAAAAABAE")!
//    }
//    
//    func getIngredientList() -> String {
//        var ingredientList = ""
//        for ingredient in ingredients {
//            ingredientList += (ingredient.food.capitalizeFirstLetter + ", ")
//        }
//        ingredientList.removeLast(2)
//        return ingredientList
//    }
//    
//    func getRecipeDuration() -> String? {
//        if totalTime != 0 {
//            let timeMeasure = Measurement(value: totalTime, unit: UnitDuration.minutes)
//            let hours = timeMeasure.converted(to: .hours)
//            if hours.value >= 1 {
//                let minutes = timeMeasure.value.truncatingRemainder(dividingBy: 60)
//                if minutes == 0 {
//                   return String(format: "%.f%@", hours.value, "h")
//                }
//                return String(format: "%.f%@%.f", hours.value, "h", minutes)
//            }
//            return String(format: "%.f%@", timeMeasure.value, "min")
//        }
//        return nil
//    }
//}
//
//struct ApiImages: Codable {
//    var THUMBNAIL: ApiImage
//    var SMALL: ApiImage
//    var REGULAR: ApiImage
//}
//
//struct ApiImage: Codable {
//    var url: String
//}
//
//struct Ingredient: Codable {
//    var text: String
//    var food: String
//    var foodId: String
//}
//
////@Model
////class Ingredient: Decodable {
////    enum CodingKeys: CodingKey {
////        case text, food, foodId
////    }
////    
////    var text: String
////    var food: String
////    var foodId: String
////    
////    init(text: String, food: String, foodId: String) {
////        self.text = text
////        self.food = food
////        self.foodId = foodId
////    }
////    
////    required init(from decoder: Decoder) throws {
////        let container = try decoder.container(keyedBy: CodingKeys.self)
////        text = try container.decode(String.self, forKey: .text)
////        food = try container.decode(String.self, forKey: .food)
////        foodId = try container.decode(String.self, forKey: .foodId)
////    }
////}
