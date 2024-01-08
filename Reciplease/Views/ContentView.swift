//
//  ContentView.swift
//  Reciplease
//
//  Created by Simon Sabatier on 07/11/2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext // modelContext tracks all the objects created, modified and deleted in the memory
    @State private var viewModel: ViewModel
    
    var body: some View {
        TabView {
            SearchView(viewModel: $viewModel)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                        .renderingMode(.template)
                    Text("Search")
                }
            FavoriteRecipesView(viewModel: $viewModel)
                .tabItem {
                    Image(systemName: "star")
                        .renderingMode(.template)
                    Text("Favorites")
                }
        }
    }
    
    init(modelContext: ModelContext) {
        let viewModel = ViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
}

//#Preview {
//    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
//}
