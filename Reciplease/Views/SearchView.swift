//
//  SearchView.swift
//  Reciplease
//
//  Created by Simon Sabatier on 07/11/2023.
//

import SwiftUI

struct SearchView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Binding var viewModel: ViewModel2
    @State var presentAlert: Bool = false
    @State var isShowingRecipesView = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                IngredientsContainerView(viewModel: $viewModel)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(20)
                Button(action: {
                    if viewModel.ingredientsIsEmpty {
                        presentAlert = true
                    } else {
                        isShowingRecipesView = true
                    }
                }, label: {
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
                    
                })
                .padding(20)
            }
            .navigationTitle("Search recipes")
            .navigationBarTitleDisplayMode(.large)
            .scrollDismissesKeyboard(.immediately)
            .alert("You have no ingredients !", isPresented: $presentAlert) {
                Button("OK", role: .cancel) {  }
            }
            .navigationDestination(isPresented: $isShowingRecipesView) {
                RecipesView(viewModel: $viewModel)
            }
            .onAppear {
//                viewModel.hasBeenFetched = false
//                print("hasBeenFetched: \(viewModel.hasBeenFetched)")
            }
        }
    }
    
//    func getRecipes() {
//        if viewModel.ingredients.isEmpty {
//            presentAlert.toggle()
//        } else {
//            viewModel.getRecipes()
//        }
//    }
}

//#Preview {
//    SearchView()
//}
