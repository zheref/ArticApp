//
//  Model.swift
//  ChicagoInstituteArt
//
//  Created by Sergio Daniel on 7/05/24.
//

import Foundation

struct ArtworksResponseBody: Decodable {
    var pagination: ArtworksPagination
    var data: [ArtworksItem]
    var config: ArtworksConfig
}

final class ArtworksConfig: Decodable {
    var iiifUrl: URL?
    
    enum CodingKeys: CodingKey {
        case iiif_url
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let iiifUrlString = try container.decode(String.self, forKey: .iiif_url)
        self.iiifUrl = URL(string: iiifUrlString)
    }
}

final class ArtworksPagination: Decodable {
    var total: Int
    var limit: Int
    var totalPages: Int
    var currentPage: Int
//    var isFavorite = false
    
    init(total: Int, limit: Int, totalPages: Int, currentPage: Int) {
        self.total = total
        self.limit = limit
        self.totalPages = totalPages
        self.currentPage = currentPage
    }
    
    enum CodingKeys: CodingKey {
        case total, limit, total_pages, current_page
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.total = try container.decode(Int.self, forKey: .total)
        self.limit = try container.decode(Int.self, forKey: .limit)
        self.totalPages = try container.decode(Int.self, forKey: .total_pages)
        self.currentPage = try container.decode(Int.self, forKey: .current_page)
    }
}

final class ArtworksItem: Decodable, Identifiable {
    var id: Int
    var title: String
    var imageId: String
    var thumbnail: ArtworkThumbnail?
    var dimensions: String?
    var artistTitle: String?
    var themeTitles: [String]
    
    init(id: Int, title: String, thumbnail: ArtworkThumbnail, imageId: String, dimensions: String, artistTitle: String, themeTitles: [String]) {
        self.id = id
        self.title = title
        self.imageId = imageId
        self.thumbnail = thumbnail
        self.dimensions = dimensions
        self.artistTitle = artistTitle
        self.themeTitles = themeTitles
    }
    
    enum CodingKeys: CodingKey {
        case id, title, thumbnail, image_id, dimensions, artist_title, theme_titles
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.imageId = try container.decode(String.self, forKey: .image_id)
        self.thumbnail = try? container.decodeIfPresent(ArtworkThumbnail.self, forKey: .thumbnail)
        self.dimensions = try? container.decodeIfPresent(String.self, forKey: .dimensions)
        self.artistTitle = try? container.decodeIfPresent(String.self, forKey: .artist_title)
        self.themeTitles = try container.decodeIfPresent([String].self, forKey: .theme_titles) ?? []
    }
}

final class ArtworkThumbnail: Decodable {
    var lqip: String?
    var width: Int
    var height: Int
    
    enum CodingKeys: CodingKey {
        case lqip
        case width
        case height
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.lqip = try container.decodeIfPresent(String.self, forKey: .lqip)
        self.width = try container.decode(Int.self, forKey: .width)
        self.height = try container.decode(Int.self, forKey: .height)
    }
}
