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
    var readValue: (String) -> String? { get }
    var storeValue: (String, String) -> Void { get }
    func store(item: ArtworksItem)
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
    
    func store(item: ArtworksItem) {
        context.insert(item)
    }
}
