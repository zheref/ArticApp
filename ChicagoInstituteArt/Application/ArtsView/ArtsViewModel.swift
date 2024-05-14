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
    var maxPagesAvailable: Int?
    var animationAmount = 2.0
    
    init(artItems: [ArtworksItem] = [], iiifUrl: URL? = nil, lastFetchedPage: Int = 0, maxPagesAvailable: Int? = nil) {
        self.artItems = artItems
        self.iiifUrl = iiifUrl
        self.lastFetchedPage = lastFetchedPage
        self.maxPagesAvailable = maxPagesAvailable
    }
}
