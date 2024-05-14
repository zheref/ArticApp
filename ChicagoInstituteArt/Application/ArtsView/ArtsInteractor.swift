//
//  ArtsInteractor.swift
//  ChicagoInstituteArt
//
//  Created by Sergio Daniel on 12/05/24.
//

import Foundation
import SwiftData
import Combine

protocol ArtsInteractorProtocol {
    func fetchArtworks()
    func fetchMoreIfNeeded(asItemShows item: ArtworksItem)
    func navigateTo(item: ArtworksItem) -> (ArtworksItem, ArtworkInteractorProtocol)
}

final class ArtsInteractor {
    static let lastIIIfUrlKey = "lastIIIfUrlKey"
    let batchLimit: Int
    
    let state: ArtsViewModel
    let provider: ArtProviderProtocol
    let service: ArtServiceProtocol
    
    var bag = Set<AnyCancellable>()
    
    init(state: ArtsViewModel, provider: ArtProviderProtocol, service: ArtServiceProtocol, batchLimit: Int = 20) {
        self.state = state
        self.provider = provider
        self.service = service
        self.batchLimit = batchLimit
    }
    
    private func preloadItemsIfNeeded() {
        do {
            let nextPageAvailableCount = try provider.countItems(forPage: state.lastFetchedPage + 1,
                                                                 limit: batchLimit)
            
            // If have available items for upcoming paging, abort
            guard nextPageAvailableCount == 0 else { return }
            
            // If we have page count available and we have reached it, abort.
            if let pagesAvailable = state.maxPagesAvailable, state.lastFetchedPage >= pagesAvailable {
                return
            }
            
            Print.debug("Preloading more items for upcoming 2 pages")
            let preloadAdvance = 2
            download(page: state.lastFetchedPage + 1, upTo: batchLimit * preloadAdvance) { [weak self] in
                self?.state.iiifUrl = $0.iiifUrl
                if let maxPagesAvailable = $0.maxPagesAvailable {
                    self?.state.maxPagesAvailable = maxPagesAvailable * preloadAdvance
                }
            }
        } catch {
            Print.error(error)
        }
    }
    
    private func next() -> Future<ArtsResult, Error> {
        let targetPage = state.lastFetchedPage + 1
        
        return .init { [weak self] send in
            guard let self = self else {
                send(.success(.none))
                return
            }
            
            Print.debug("Fetching page \(targetPage) of \(state.maxPagesAvailable ?? 0)")
            
            do {
                let items = try provider.fetchItems(forPage: targetPage, countLimit: batchLimit)
                if let iiifUrlString = provider.readValue(Self.lastIIIfUrlKey) {
                    let iiifUrl = URL(string: iiifUrlString)
                    
                    if items.isEmpty {
                        self.download(page: targetPage, upTo: batchLimit) { send(.success($0)) }
                    } else {
                        send(.success(.init(items: items, maxPagesAvailable: nil, iiifUrl: iiifUrl)))
                    }
                } else {
                    self.download(page: targetPage, upTo: batchLimit) { send(.success($0)) }
                }
            } catch {
                send(.failure(error))
            }
        }
    }
    
    private func download(page: Int, upTo limit: Int, completion: @escaping (ArtsResult) -> Void) {
        Print.debug("Retrieving page \(page) from network")
        Task { [unowned self] in
            do {
                let result = try await self.service.fetchArtworks(page: page, countLimit: limit)
                if let iiifUrlString = result.iiifUrl?.absoluteString {
                    self.provider.storeValue(Self.lastIIIfUrlKey, iiifUrlString)
                }
                await MainActor.run { @Sendable in
                    for item in result.items {
                        do {
                            try provider.store(item: item, autosaving: true)
                        } catch {
                            Print.error(error)
                        }
                    }
                    
                    let persistedItems = try? provider.fetchItems(forPage: page, countLimit: limit)
                    completion(.init(items: persistedItems ?? [],
                                     maxPagesAvailable: result.maxPagesAvailable,
                                     iiifUrl: result.iiifUrl))
                }
            } catch {
                Print.error(error)
            }
        }
    }
    
    private func handle(error: Error) {
        Print.error(error)
    }
    
}

extension ArtsInteractor: ArtsInteractorProtocol {
    
    /// Fetches more items from local provider as the UI requires it for presentation purposes
    /// - Parameter: item: The item being presented to determine whether more fetching is needed or not
    func fetchMoreIfNeeded(asItemShows item: ArtworksItem) {
        guard state.artItems.last == item else {
            return
        }
        
        // If we have page count available and we have reached it, abort.
        if let pagesAvailable = state.maxPagesAvailable, state.lastFetchedPage >= pagesAvailable {
            Print.debug("Not fetching more pages as there are no more")
            return
        }
        
        fetchArtworks()
    }
    
    /// Fetches artworks for incoming page
    func fetchArtworks() {
        Print.debug("Requesting more artworks to data sources...")
        next()
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.handle(error: error)
                case .finished:
                    self?.state.lastFetchedPage += 1
                    self?.preloadItemsIfNeeded()
                }
            } receiveValue: { [weak self] result in
                self?.state.artItems.append(contentsOf: result.items)
                self?.state.iiifUrl = result.iiifUrl
                if let maxPagesAvailable = result.maxPagesAvailable {
                    self?.state.maxPagesAvailable = maxPagesAvailable
                }
            }
            .store(in: &bag)
    }
    
    func navigateTo(item: ArtworksItem) -> (ArtworksItem, ArtworkInteractorProtocol) {
        return (
            item: item,
            interactor: ArtworkInteractor(item: item, provider: provider)
        )
    }
    
}
