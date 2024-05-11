//
//  ArtService.swift
//  ChicagoInstituteArt
//
//  Created by Sergio Daniel on 7/05/24.
//

import Foundation

protocol ArtServiceProtocol {
    func fetchArtworks(page: Int) async throws -> (items: [ArtworksItem], iiifUrl: URL?)
}

struct ArtService: ArtServiceProtocol {
    let client: REST.Client
    
    init(client: REST.Client) {
        self.client = client
    }
    
    func fetchArtworks(page: Int) async throws -> (items: [ArtworksItem], iiifUrl: URL?) {
        print("Fetching artworks for page: \(page)")
        let response: ArtworksResponseBody = try await client.request(
            fromEndpoint: ArtEndpoint.artworks(page: page)
        )
        return (items: response.data, iiifUrl: response.config.iiifUrl)
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