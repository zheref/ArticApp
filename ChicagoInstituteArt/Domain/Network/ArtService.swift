//
//  ArtService.swift
//  ChicagoInstituteArt
//
//  Created by Sergio Daniel on 7/05/24.
//

import Foundation



protocol ArtServiceProtocol {
    func fetchArtworks(page: Int, countLimit: Int) async throws -> ArtsResult
}

struct ArtService: ArtServiceProtocol {
    let client: REST.Client
    
    init(client: REST.Client) {
        self.client = client
    }
    
    func fetchArtworks(page: Int, countLimit: Int) async throws -> ArtsResult {
        print("Fetching artworks for page: \(page)")
        let response: ArtworksResponseBody = try await client.request(
            fromEndpoint: ArtEndpoint.artworks(page: page, limit: countLimit)
        )
        return .init(items: response.data,
                     maxPagesAvailable: response.pagination.totalPages,
                     iiifUrl: response.config.iiifUrl)
    }
}

extension REST.Client {
    
    static var forPreviews: Self {
        REST.Client(
            fetchAsync: {
                (data: .fromJSONFile(withName: "artworks")!, response: .raw(url: $1.url!))
            }
        )
    }
    
}
