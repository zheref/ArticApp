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
}

final class ArtsInteractor: ArtsInteractorProtocol {
    static let lastIIIfUrlKey = "lastIIIfUrlKey"
    static let limit = 20
    
    let state: ArtsViewModel
    let provider: ArtProviderProtocol
    let service: ArtServiceProtocol
    
    var bag = Set<AnyCancellable>()
    
    init(state: ArtsViewModel, provider: ArtProviderProtocol, service: ArtServiceProtocol) {
        self.state = state
        self.provider = provider
        self.service = service
    }
    
    func fetchArtworks() {
        next()
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.handle(error: error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] items, iiifUrl in
                self?.state.artItems = items
                self?.state.iiifUrl = iiifUrl
                self?.state.lastFetchedPage += 1
            }
            .store(in: &bag)
    }
    
    private func next() -> Future<ArtsResult, Error> {
        let targetPage = state.lastFetchedPage + 1
        
        return .init { [weak self] send in
            guard let self = self else {
                send(.success((items: [], iiifUrl: nil)))
                return
            }
            
            do {
                let items = try provider.fetchItems(forPage: targetPage, countLimit: Self.limit)
                if let iiifUrlString = provider.readValue(Self.lastIIIfUrlKey) {
                    let iiifUrl = URL(string: iiifUrlString)
                    
                    if items.isEmpty {
                        self.retrieve(page: targetPage, upTo: Self.limit) { send(.success($0)) }
                    } else {
                        send(.success((items: items, iiifUrl: iiifUrl)))
                    }
                } else {
                    self.retrieve(page: targetPage, upTo: Self.limit) { send(.success($0)) }
                }
            } catch {
                send(.failure(error))
            }
        }
    }
    
    private func retrieve(page: Int, upTo limit: Int, completion: @escaping (ArtsResult) -> Void) {
        Task { [unowned self] in
            let (items, iiifUrl) = try await self.service.fetchArtworks(page: page, countLimit: limit)
            if let iiifUrlString = iiifUrl?.absoluteString {
                self.provider.storeValue(Self.lastIIIfUrlKey, iiifUrlString)
            }
            await MainActor.run {
                for item in items {
                    provider.store(item: item)
                }
            }
            completion((items: items, iiifUrl: iiifUrl))
        }
    }
    
    private func handle(error: Error) {
        Print.error(error)
    }
    
}
