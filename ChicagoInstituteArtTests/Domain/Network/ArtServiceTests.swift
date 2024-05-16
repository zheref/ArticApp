//
//  ArtServiceTests.swift
//  ChicagoInstituteArtTests
//
//  Created by Sergio Daniel on 15/05/24.
//

@testable import ChicagoInstituteArt
import XCTest

final class ArtServiceTests: XCTestCase {

    func testFetchArworks() async {
        let sut = ArtService(client: .whenSomeData)
        do {
            let result = try await sut.fetchArtworks(page: 1, countLimit: 21)
            XCTAssertEqual(result.items.count, 21)
            XCTAssertEqual(result.maxPagesAvailable, 5990)
            XCTAssertEqual(result.iiifUrl, URL(string: "https://www.artic.edu/iiif/2")!)
        } catch {
            XCTFail("Failed with error: \(error.localizedDescription)")
        }
    }
    
    func testFetchArworks_consideringLimit() async {
        let originalItems: [ArtworksItem] = [
            .mock, .mock2, .mock3, .mock, .mock2, .mock3, .mock, .mock2, .mock3
        ]
        
        let sut = ArtService(client: .whenSpecific(items: originalItems, currentPage: 1))
        do {
            let result = try await sut.fetchArtworks(page: 1, countLimit: originalItems.count)
            XCTAssertEqual(result.items.count, originalItems.count)
            XCTAssertEqual(result.maxPagesAvailable, 1000 / originalItems.count)
            XCTAssertEqual(result.iiifUrl, URL(string: "https://www.artic.edu/iiif/2")!)
        } catch {
            XCTFail("Failed with error: \(error.localizedDescription)")
        }
    }

}


extension REST.Client {
    
    static func whenSpecific(items: [ArtworksItem], currentPage: Int) -> Self {
        let total = 1000
        let responseBody = ArtworksResponseBody(
            pagination: .init(total: total,
                              limit: items.count,
                              totalPages: total / items.count,
                              currentPage: currentPage),
            data: items,
            config: .init(iiifUrl: .iiifMock)
        )
        
        let responseAsData = (try? JSONEncoder().encode(responseBody)) ?? Data(count: 0)
        
        return REST.Client(
            fetchAsync: {
                (data: responseAsData, response: .raw(url: $1.url!))
            }
        )
    }
    
    static var whenSomeData: Self {
        REST.Client(
            fetchAsync: {
                (data: .fromJSONFile(withName: "artworks")!, response: .raw(url: $1.url!))
            }
        )
    }
    
    static var whenNoData: Self {
        REST.Client(
            fetchAsync: {
                (data: .fromJSONFile(withName: "artworks")!, response: .raw(url: $1.url!))
            }
        )
    }
    
}
