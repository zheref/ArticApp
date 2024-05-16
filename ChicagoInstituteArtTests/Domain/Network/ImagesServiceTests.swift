//
//  ArtEndpointTests.swift
//  ChicagoInstituteArtTests
//
//  Created by Sergio Daniel on 16/05/24.
//

@testable import ChicagoInstituteArt
import XCTest

final class ImagesServiceTests: XCTestCase {

    func testImageUrlUsingIIIFUrl_whenImageIdIsPresent() {
        let sut = ArtworksItem.mock
        let generatedUrl = sut.imageUrl(usingIIIFUrl: .iiifMock!)
        XCTAssertNotNil(generatedUrl)
        XCTAssertEqual(
            generatedUrl?.absoluteString,
            "https://www.artic.edu/iiif/2/2193cdda-2691-2802-0776-145dee77f7ea/full/843,/0/default.jpg"
        )
    }
    
    func testImageUrlUsingIIIFUrl_whenImageIdNotPresent() {
        let sut = ArtworksItem.mockWithNoImage
        let generatedUrl = sut.imageUrl(usingIIIFUrl: .iiifMock!)
        XCTAssertNil(generatedUrl)
    }

}
