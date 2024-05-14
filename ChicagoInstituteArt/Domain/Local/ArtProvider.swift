//
//  ArtProvider.swift
//  ChicagoInstituteArt
//
//  Created by Sergio Daniel on 13/05/24.
//

import Foundation
import SwiftData

protocol ArtProviderProtocol {
    func fetchItems(forPage page: Int, countLimit: Int) throws -> [ArtworksItem]
    func countItems(forPage page: Int, limit: Int) throws -> Int
    var readValue: (String) -> String? { get }
    var storeValue: (String, String) -> Void { get }
    func store(item: ArtworksItem, autosaving shouldAutoSave: Bool) throws
    func commit() throws
}

struct ArtProvider: ArtProviderProtocol {
    let context: ModelContext
    
    var readValue: (String) -> String? = { UserDefaults.standard.string(forKey: $0) }
    var storeValue: (String, String) -> Void = { UserDefaults.standard.setValue($1, forKey: $0) }
    
    func fetchItems(forPage page: Int, countLimit: Int) throws -> [ArtworksItem] {
        var descriptor = FetchDescriptor<ArtworksItem>()
        descriptor.fetchLimit = countLimit
        descriptor.fetchOffset =  countLimit * (page - 1)
        return try context.fetch(descriptor)
    }
    
    func countItems(forPage page: Int, limit: Int) throws -> Int {
        var descriptor = FetchDescriptor<ArtworksItem>()
        descriptor.fetchLimit = limit
        descriptor.fetchOffset =  limit * (page - 1)
        return try context.fetchCount(descriptor)
    }
    
    func store(item: ArtworksItem, autosaving shouldAutoSave: Bool = false) throws {
        context.insert(item)
        if shouldAutoSave {
            try context.save()
        }
    }
    
    func commit() throws {
        try context.save()
    }
}
