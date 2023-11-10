////
////  ViewModel.swift
////  Reciplease
////
////  Created by Simon Sabatier on 07/11/2023.
////
//
//import Foundation
//import SwiftData
//
//extension ContentView {
//    
//    @Observable
//    class ViewModel {
//        var modelContext: ModelContext
//        
//        var ingredients: [String] = []
//        var recipes: [ApiResponse.RecipeObject.RecipeModel] = []
//        //var recipeObjects: [RecipeObject] = []
//        
//        var hasError: Bool = false
//        var isRefreshing: Bool = false
//        var ingredientsIsEmpty: Bool = true
//        var hasBeenFetched: Bool = false
//        
//        init(modelContext: ModelContext) {
//            self.modelContext = modelContext
//        }
//        
//        func getRecipes() {
//            self.isRefreshing = true
//            self.recipes = []
//            let type = "&type=public"
//            let endpoint = "https://api.edamam.com/api/recipes/v2?"
//            
//            var ingredientsQuery = ""
//            for ingredient in ingredients {
//                ingredientsQuery += (ingredient + ",")
//            }
//            print(ingredientsQuery)
//            
//            if let url = URL(string: endpoint + type + appId + appKey + "&q=" + ingredientsQuery) {
//                print(endpoint + type + appId + appKey + "&q=" + ingredientsQuery)
//                URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
//                    DispatchQueue.main.async {
//                        guard let data = data, error == nil else {
//                            self?.hasError = true
//                            self?.isRefreshing = false
//                            print("Has Error")
//                            return
//                        }
//                        let decoder = JSONDecoder()
//                        if let response = try? decoder.decode(Response.self, from: data) {
//                            print("decoding good")
//                            print(response.hits.count)
//                            if !(response.hits.isEmpty) {
//                                for recipeObject in response.hits {
//                                    self?.recipes.append(recipeObject.recipe)
//                                }
//                            }
//                            self?.isRefreshing = false
//                            self?.hasBeenFetched = true
//                        }
//                    }
//                }.resume()
//            }
//        }
//        
//func addRecipeToFavorite(recipe: Recipe) {
//    print(recipe.ingredients)
//    self.modelContext.insert(recipe)
//    do {
//        try modelContext.save()
//    } catch {
//        print(error)
//    }
//}
//
//func removeRecipeFromFavorite(recipe: Recipe) {
//    print(recipe.ingredients)
//    self.modelContext.delete(recipe)
//    do {
//        try modelContext.save()
//    } catch {
//        print(error)
//    }
//}
//        
//        func addIngredient(ingredient: String) {
//            var ingredient = ingredient
//            let letters = NSCharacterSet.letters
//            let range = ingredient.rangeOfCharacter(from: letters)
//            if let _ = range {
//                if ingredient.last == " " {
//                    ingredient.removeLast()
//                }
//                ingredients.append(ingredient.capitalizeFirstLetter)
//                self.ingredientsIsEmpty = false
//            }
//            print(ingredients)
//        }
//        
//        func clearIngredients() {
//            self.ingredients = []
//            self.ingredientsIsEmpty = true
//        }
//        
//        private var appId: String {
//            get {
//                guard let filePath = Bundle.main.path(forResource: "config", ofType: "plist") else {
//                    fatalError("Couldn't find file 'config.plist'.")
//                }
//                
//                let plist = NSDictionary(contentsOfFile: filePath)
//                guard let value = plist?.object(forKey: "app_id") as? String else {
//                    fatalError("Couldn't find key 'app_id' in 'config.plist'.")
//                }
//                return value
//            }
//        }
//        
//        private var appKey: String {
//            get {
//                guard let filePath = Bundle.main.path(forResource: "config", ofType: "plist") else {
//                    fatalError("Couldn't find file 'config.plist'.")
//                }
//                
//                let plist = NSDictionary(contentsOfFile: filePath)
//                guard let value = plist?.object(forKey: "app_key") as? String else {
//                    fatalError("Couldn't find key 'app_key' in 'config.plist'.")
//                }
//                return value
//            }
//        }
//    }
//}
