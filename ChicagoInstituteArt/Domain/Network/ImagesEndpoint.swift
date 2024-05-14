//
//  ImagesEndpoint.swift
//  ChicagoInstituteArt
//
//  Created by Sergio Daniel on 10/05/24.
//

import Foundation

enum ImagesEndpoint: REST.Endpoint {
    
    case image(iiifUrl: URL, imageId: String)
    
    var baseUrl: String {
        switch self {
        case .image(let iiifUrl, _):
            return iiifUrl.rfc1808Host ?? ""
        }
    }
    
    var route: String {
        switch self {
        case .image(let iiifUrl, let imageId):
            let basePath = iiifUrl.rfc1808BasedPath ?? ""
            return "\(basePath)/\(imageId)/full/843,/0/default.jpg"
        }
    }
    
    var method: REST.Method {
        switch self {
        case .image(_, _):
            return .get
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .image(_, _):
            return nil
        }
    }
    
    var headers: [String : String]? { [:] }
    
}

#if DEBUG
extension URL {
    static var iiifMock: URL? { URL(string: "https://www.artic.edu/iiif/2") }
}
#endif
