//
//  ArtsViewModel.swift
//  ChicagoInstituteArt
//
//  Created by Sergio Daniel on 13/05/24.
//

import SwiftUI

@Observable class ArtsViewModel {
    var artItems: [ArtworksItem] = []
    var iiifUrl: URL?
    var lastFetchedPage = 0
    
    init(artItems: [ArtworksItem] = [], iiifUrl: URL? = nil, lastFetchedPage: Int = 0) {
        self.artItems = artItems
        self.iiifUrl = iiifUrl
        self.lastFetchedPage = lastFetchedPage
    }
}
