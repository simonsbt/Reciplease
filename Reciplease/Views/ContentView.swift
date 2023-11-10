//
//  ContentView.swift
//  Reciplease
//
//  Created by Simon Sabatier on 07/11/2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: ViewModel2 = ViewModel2()
    
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
    
//    init(modelContext: ModelContext) {
//        let viewModel = ViewModel2(modelContext: modelContext)
//        _viewModel = State(initialValue: viewModel)
//    }
}

//#Preview {
//    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
//}


//        NavigationSplitView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
//                    } label: {
//                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//        } detail: {
//            Text("Select an item")
//        }
