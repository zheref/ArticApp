//
//  ModelContainer+Live.swift
//  ChicagoInstituteArt
//
//  Created by Sergio Daniel on 12/05/24.
//

import Foundation
import SwiftData

extension ModelContainer {
    static let modelsForAppContext: [any PersistentModel.Type] = [ArtworksItem.self]
    
    @MainActor
    static let live: ModelContainer = {
        let schema = Schema(modelsForAppContext)
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            container.mainContext.autosaveEnabled = false
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
}

extension ModelContext {
    var sqliteCommand: String {
        if let url = container.configurations.first?.url.path(percentEncoded: false) {
            "sqlite3 \"\(url)\""
        } else {
            "No SQLite database found."
        }
    }
}

actor PreviewSampleData {
    @MainActor
    static let previewSomeItems: ModelContainer = {
        let schema = Schema(ModelContainer.modelsForAppContext)
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [modelConfiguration])
        container.mainContext.autosaveEnabled = false
        container.mainContext.insert(ArtworksItem.mock)

        return container
    }()
    
    @MainActor
    static let previewNoItems: ModelContainer = {
        let schema = Schema(ModelContainer.modelsForAppContext)
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [modelConfiguration])
        container.mainContext.autosaveEnabled = false
        return container
    }()
}
