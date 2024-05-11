//
//  ArtEndpoint.swift
//  ChicagoInstituteArt
//
//  Created by Sergio Daniel on 8/05/24.
//

import Foundation

enum ArtEndpoint: REST.Endpoint {
    case artworks(page: Int)
    case artwork(artId: String)
    
    var baseUrl: String { "https://api.artic.edu" }
    
    var route: String {
        let versionPath = "/api/v1"
        
        switch self {
        case .artworks(_):
            return "\(versionPath)/artworks"
        case .artwork(let artId):
            return "\(versionPath)/artworks/\(artId)"
        }
    }
    
    var method: REST.Method {
        switch self {
        case .artworks(_):
            return .get
        case .artwork(_):
            return .get
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .artworks(let page):
            guard page > 0 else { return nil }
            return [
                "page": "\(page)",
                "limit": "10",
                "fields": "id,title,thumbnail,dimensions,artist_title,artist_display,date_display,main_reference_number,theme_titles,image_id"
            ]
        default:
            return nil
        }
    }
    
    var headers: [String : String]? {
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        return headers
    }
}
