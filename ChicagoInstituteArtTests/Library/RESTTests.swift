//
//  RESTTests.swift
//  ChicagoInstituteArtTests
//
//  Created by Sergio Daniel on 11/05/24.
//

@testable import ChicagoInstituteArt
import XCTest

final class RESTTests: XCTestCase {
    
    func testRFC1808Host() {
        let sut = URL(string: "https://www.artic.edu/iiif/2")!
        XCTAssertEqual(sut.rfc1808Host, "https://www.artic.edu")
        XCTAssertEqual(sut.rfc1808BasedPath, "/iiif/2")
    }
    
}
