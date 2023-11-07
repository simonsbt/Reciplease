//
//  IngredientsContainerView.swift
//  Reciplease
//
//  Created by Simon Sabatier on 07/11/2023.
//

import SwiftUI
import SwiftData

struct IngredientsContainerView: View {
    
    @StateObject var vm: SearchViewModel
    
    @State var ingredientToAdd = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("What's in your fridge ?")
                    .font(.title3)
                    .bold()
                Spacer()
                Button(action: {
                    withAnimation {
                        vm.clearIngredients()
                    }
                    
                }, label: {
                    Text("Clear")
                })
            }
            .padding()
            if $vm.ingredients.isEmpty {
                Text("You have no ingredient for now.")
                    .foregroundStyle(.secondary)
                    .padding()
            } else {
                VStack(alignment: .leading) {
                    ForEach($vm.ingredients, id: \.self) { $ingredient in
                        Text("- " + ingredient)
                    }
                }
                .padding()
            }
            HStack {
                TextField("Add an ingredient", text: $ingredientToAdd)
                    .submitLabel(.done)
                    .onSubmit {
                        self.ingredientToAdd = ""
                    }
                    .padding(6)
                Button(action: {
                    withAnimation {
                        vm.addIngredient(ingredient: ingredientToAdd)
                        self.ingredientToAdd = ""
                    }
                }, label: {
                    Text("Add")
                })
                .padding(8)
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding()
        }
        .background(Color(white: 0.95))
    }
    
    
}

//#Preview {
//    IngredientsContainerView()
//}
