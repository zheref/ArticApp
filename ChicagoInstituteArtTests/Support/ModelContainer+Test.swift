//
//  ModelContainer+Test.swift
//  ChicagoInstituteArtTests
//
//  Created by Sergio Daniel on 16/05/24.
//

import Foundation
import SwiftData
@testable import ChicagoInstituteArt

extension ModelContainer {
    
    @MainActor
    static let mockWithNoData: ModelContainer = {
        let schema = Schema(ModelContainer.modelsForAppContext)
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [modelConfiguration])
        container.mainContext.autosaveEnabled = false
        return container
    }()
    
    @MainActor
    static let mockWithInitialData: ModelContainer = {
        let schema = Schema(ModelContainer.modelsForAppContext)
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [modelConfiguration])
        container.mainContext.autosaveEnabled = false
        container.mainContext.insert(ArtworksItem.mock)
        container.mainContext.insert(ArtworksItem.mock2)
        container.mainContext.insert(ArtworksItem.mock3)
        return container
    }()
    
}
