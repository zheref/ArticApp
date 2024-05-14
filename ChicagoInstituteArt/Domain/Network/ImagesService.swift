//
//  ImagesService.swift
//  ChicagoInstituteArt
//
//  Created by Sergio Daniel on 13/05/24.
//

import Foundation

extension ArtworksItem {
    
    func imageUrl(usingIIIFUrl iiifUrl: URL) -> URL? {
        let endpoint = ImagesEndpoint.image(iiifUrl: iiifUrl, imageId: imageId)
        return try? endpoint.createURL()
    }
    
}
