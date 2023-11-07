//
//  SearchView.swift
//  Reciplease
//
//  Created by Simon Sabatier on 07/11/2023.
//

import SwiftUI

struct SearchView: View {
    
    @StateObject var vm: SearchViewModel = SearchViewModel()
    @State var presentAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                IngredientsContainerView(vm: vm)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(20)
                NavigationLink(destination: RecipesView(vm: vm)) {
                    HStack {
                        Spacer()
                        Text("Search !")
                            .foregroundStyle(.white)
                            .bold()
                            .padding()
                        Spacer()
                    }
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(20)
                }
            }
            .navigationTitle("Search recipes")
            .navigationBarTitleDisplayMode(.large)
            .scrollDismissesKeyboard(.interactively)
            .alert("You have no ingredients !", isPresented: $presentAlert) {
                Button("OK", role: .cancel) {  }
            }
        }
    }
    
    func getRecipes() {
        if vm.ingredients.isEmpty {
            presentAlert.toggle()
        } else {
            vm.getRecipes()
        }
    }
}

#Preview {
    SearchView()
}
