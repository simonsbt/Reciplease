//
//  SearchView.swift
//  Reciplease
//
//  Created by Simon Sabatier on 07/11/2023.
//

import SwiftUI

struct SearchView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Binding var viewModel: ViewModel
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
                        Text("Search recipes !")
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
            .scrollDismissesKeyboard(.interactively)
            .alert("You have no ingredients !", isPresented: $presentAlert, actions: {
                Button("OK", role: .cancel) {  }
            }, message: {
                Text("Please add some ingredients before searching for recipes.")
            })
            .navigationDestination(isPresented: $isShowingRecipesView) {
                RecipesView(viewModel: $viewModel) // Presents RecipesView() when needed
            }
            .onAppear {
                viewModel.hasBeenFetched = false
            }
        }
    }
}

//#Preview {
//    SearchView()
//}
