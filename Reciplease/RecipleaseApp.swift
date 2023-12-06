//
//  RecipleaseApp.swift
//  Reciplease
//
//  Created by Simon Sabatier on 07/11/2023.
//

import SwiftUI
import SwiftData

@main
struct RecipleaseApp: App {
    let container: ModelContainer

    var body: some Scene {
        WindowGroup {
            ContentView(modelContext: container.mainContext)
                .modelContainer(container)
        }
    }
    
    init() {
        do {
            container = try ModelContainer(for: Recipe.self)
        } catch {
            fatalError("Failed to configure SwiftData container.")
        }
    }
}
