//
//  Serialization.swift
//  ChicagoInstituteArt
//
//  Created by Sergio Daniel on 8/05/24.
//

import Foundation
import Combine

extension Decodable {}

protocol Serializer {
    associatedtype Model
    func decode(data: Data) throws -> Model
}

extension Publisher where Output == Data {
    func decode<S: Serializer>(using serializer: S) -> Publishers.TryMap<Self, S.Model> {
        tryMap { try serializer.decode(data: $0) }
    }
}

struct JSONSerializer<M: Decodable>: Serializer {
    typealias Model = M
    
    func decode(data: Data) throws -> M {
        try JSONDecoder().decode(Model.self, from: data)
    }
}
