//
//  DevHelpers.swift
//  ChicagoInstituteArt
//
//  Created by Sergio Daniel on 14/05/24.
//

import Foundation
import SwiftData

#if DEBUG
actor PreviewSampleData {
    @MainActor
    static let previewSomeItems: ModelContainer = {
        let schema = Schema(ModelContainer.modelsForAppContext)
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [modelConfiguration])
        container.mainContext.autosaveEnabled = false
        container.mainContext.insert(ArtworksItem.mock)
        container.mainContext.insert(ArtworksItem.mock2)

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

extension ModelContainer {
    @MainActor
    func firstInstance<T: PersistentModel>() -> T? {
        let descriptor = FetchDescriptor<T>()
        guard let results = try? mainContext.fetch(descriptor) else { return nil }
        return results.first
    }
}
#endif
