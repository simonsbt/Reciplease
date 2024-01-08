//
//  Recipe.swift
//  Reciplease
//
//  Created by Simon Sabatier on 07/11/2023.
//

import Foundation
import SwiftData
import SwiftUI
import Alamofire

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
            
            /// Return an array with the ingredients details
            func getIngredientTextList() -> [String] {
                var list: [String] = []
                for ingredient in ingredients {
                    list.append(ingredient.text)
                }
                return list
            }
            
            /// Return an array with the ingredients list
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
    
    /// Fetch recipes with a callback sending an ApiResponse or an Error
    static private func fetchRecipes(url: String, completion: @escaping (Result<ApiResponse, Error>) -> Void) {

        /// Alamofire call
        AF.request(url).response { response in
            switch response.result {
            case .success(let data):
                do {
                    let apiResponse = try JSONDecoder().decode(ApiResponse.self, from: data!)
                    completion(.success(apiResponse))
                } catch {
                    completion(.failure(FetchError.wrongDataFormat(error: error)))
                }
            case .failure(_):
                print("failure")
                completion(.failure(FetchError.missingData))
            }
        }
    }
    
    static func getRecipes (modelContext: ModelContext, ingredients: [String], completion: @escaping (Result<ApiResponse, Error>) -> Void) {
        let type = "&type=public"
        let endpoint = "https://api.edamam.com/api/recipes/v2?"
        let appId = getAppAuth(auth: .app_id)
        let appKey = getAppAuth(auth: .app_key)
        
        var ingredientsQuery = ""
        for ingredient in ingredients {
            ingredientsQuery += (ingredient + ",")
        }
        let url = endpoint + type + appId + appKey + "&q=" + ingredientsQuery
        
        fetchRecipes(url: url, completion: completion)
    }
    
    /// Return the auth keys for the API call
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
