//
//  RecipesView.swift
//  Reciplease
//
//  Created by Simon Sabatier on 07/11/2023.
//

import SwiftUI

struct RecipesView: View {
    
    @StateObject var vm: SearchViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                vm.getRecipes()
            }
    }
}

//#Preview {
//    RecipesView()
//}
