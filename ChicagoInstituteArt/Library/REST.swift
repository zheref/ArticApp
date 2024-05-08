//
//  REST.swift
//  ContestOfSwift
//
//  Created by Sergio Daniel on 7/05/24.
//

import Foundation
import Combine

enum REST {
    enum Method: String {
        case get
        case post
        case put
        case patch
        case delete

        var spelled: String { rawValue.uppercased() }
    }
    
    enum EndpointError: Error {
        case malformedUrl
    }
    
    enum ClientError: Error {}
    
    protocol Endpoint {
        var baseUrl: String { get }
        var route: String { get }
        var method: Method { get }
        
        var headers: [String: String]? { get }
        var body: Data? { get }
        var queryParameters: [String: String]? { get }
        
        func createRequest() throws -> URLRequest
    }
    
    typealias URLResponsePair = (data: Data, response: URLResponse)
    typealias URLResponsePublisher = AnyPublisher<URLResponsePair, URLError>

    struct Client {
        var session: URLSession = .shared
        
        var fetchAsync: (URLSession, URLRequest) async throws -> URLResponsePair = { try await $0.data(for: $1) }
        var fetchPublisher: (URLSession, URLRequest) -> URLResponsePublisher = { $0.dataTaskPublisher(for: $1).eraseToAnyPublisher() }
        var fetchWithCompletion: (URLSession, URLRequest, @escaping (Data?, URLResponse?, Error?) -> Void) -> Void = { $0.dataTask(with: $1, completionHandler: $2) }
        
        func request<Model: Decodable>(fromEndpoint endpoint: Endpoint) async throws -> Model {
            let request = try endpoint.createRequest()
            print("Request: \(String(describing: request.url))")
            let (data, _) = try await fetchAsync(session, request)
            return try JSONDecoder().decode(Model.self, from: data)
        }
        
        func endpoint<Model: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<Model, Error> {
            do {
                let request = try endpoint.createRequest()
                return fetchPublisher(session, request)
                    .map(\.data)
                    .decode(type: Model.self, decoder: JSONDecoder())
                    .eraseToAnyPublisher()
            } catch {
                return Fail<Model, Error>(error: error).eraseToAnyPublisher()
            }
        }
        
    }
}

extension URLQueryItem {
    static func from(_ kv: (String, String)) -> URLQueryItem {
        return .init(name: kv.0, value: kv.1)
    }
}

extension URLResponse {
    static func raw(url: URL) -> URLResponse {
        .init(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
}

extension REST.Endpoint {
    var body: Data? { nil }
    var queryParameters: [String: String]? { nil }
    
    func createRequest() throws -> URLRequest {
        var urlComponents = URLComponents(string: baseUrl)
        urlComponents?.path = route
        urlComponents?.queryItems = queryParameters?.map(URLQueryItem.from)
        
        guard let url = urlComponents?.url else { throw REST.EndpointError.malformedUrl }
        var request = URLRequest(url: url)
        request.httpMethod = method.spelled
        request.httpBody = body
        
        if let headers = headers {
            headers.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        }
        
        return request
    }
}
