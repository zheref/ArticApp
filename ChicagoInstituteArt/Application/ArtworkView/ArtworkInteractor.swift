//
//  ArtworkInteractor.swift
//  ChicagoInstituteArt
//
//  Created by Sergio Daniel on 13/05/24.
//

import Foundation

protocol ArtworkInteractorProtocol {
    func toggleFavorite()
}

struct ArtworkInteractor: ArtworkInteractorProtocol {
    let item: ArtworksItem
    let provider: ArtProviderProtocol
    
    init(item: ArtworksItem, provider: ArtProviderProtocol) {
        self.item = item
        self.provider = provider
    }
    
    private func handle(error: Error) {
        Print.error(error)
    }
}

extension ArtworkInteractor {
    func toggleFavorite() {
        item.isFavorite.toggle()
        do {
            try provider.commit()
        } catch {
            self.handle(error: error)
        }
    }
}
