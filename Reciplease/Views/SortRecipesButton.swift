//
//  SortRecipesButton.swift
//  Reciplease
//
//  Created by Simon Sabatier on 12/11/2023.
//

import SwiftUI

struct SortRecipesButton: View {
    @Binding var viewModel: ViewModel
    
    let sortOrder: [String] = ["Forward", "Reverse"]
    let sortOptions: [String] = ["Duration", "Name"]
    
    var body: some View {
        Menu {
            Picker("Sort Order", selection: $viewModel.selectedSortOrder) {
                ForEach(viewModel.sortOrder, id: \.self) { order in
                    Text(order)
                }
            }
            Picker("Sort By", selection: $viewModel.selectedSortOption) {
                ForEach(viewModel.sortOptions, id: \.self) { option in
                    Text(option)
                }
            }
        } label: {
            Label("Sort", systemImage: "arrow.up.arrow.down")
        }
        .pickerStyle(.inline)
    }
}

//#Preview {
//    SortRecipesButton()
//}
