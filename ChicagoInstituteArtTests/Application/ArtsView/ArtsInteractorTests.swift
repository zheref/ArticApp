//
//  ArtsInteractorTests.swift
//  ChicagoInstituteArtTests
//
//  Created by Sergio Daniel on 16/05/24.
//

@testable import ChicagoInstituteArt
import XCTest
import SwiftData
import Combine

final class ArtsInteractorTests: XCTestCase {
    
    override class func setUp() {
        super.setUp()
    }

    @MainActor
    func testViewDidLoad_whenNoArtItems() {
        // Given
        let state = ArtsViewModel()
        let container = ModelContainer.mockWithNoData
        
        let expectation = XCTestExpectation(description: "Network request has been resolved")
        XCTAssertEqual(state.artItems.count, 0)
        
        let sut = ArtsInteractorWithSpies(
            state: state,
            provider: ArtProvider(context: container.mainContext),
            service: ArtService(client: .whenSomeData),
            batchLimit: 21
        )
        
        // When
        sut.fetchCompletion = { _ in expectation.fulfill() }
        sut.viewDidLoad()
        wait(for: [expectation], timeout: 2.0)
        
        // Then
        XCTAssertTrue(sut.startedFetchingArtworks)
        XCTAssertEqual(state.artItems.count, 21)
    }
    
    @MainActor
    func testViewDidLoad_whenThereAreArtItems() {
        // Given
        let state = ArtsViewModel(
            artItems: [
                .mock, .mock2, .mock3, .mockWithNoImage
            ]
        )
        let container = ModelContainer.mockWithNoData
        
        XCTAssertEqual(state.artItems.count, 4)
        
        let sut = ArtsInteractorWithSpies(
            state: state,
            provider: ArtProvider(context: container.mainContext),
            service: ArtService(client: .init()),
            batchLimit: 20
        )
        
        // When
        sut.viewDidLoad()
        
        // Then
        XCTAssertFalse(sut.startedFetchingArtworks)
        XCTAssertEqual(state.artItems.count, 4)
    }

}

class ArtsInteractorWithSpies: ArtsInteractor {
    
    var startedFetchingArtworks = false
    var fetchCompletion: ((Subscribers.Completion<any Error>) -> Void)?
    
    override func fetchArtworks() -> Future<ArtsResult, Error> {
        startedFetchingArtworks = true
        let future = super.fetchArtworks()
        future.sink { [weak self] completion in
            self?.fetchCompletion?(completion)
        } receiveValue: { _ in }
        .store(in: &bag)

        return future
    }
    
}
