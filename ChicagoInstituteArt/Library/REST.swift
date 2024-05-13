//
//  REST.swift
//  ContestOfSwift
//
//  Created by Sergio Daniel on 7/05/24.
//

import Foundation
import Combine

enum REST {
    // MARK: - Convenience Types
    
    enum Method: String {
        case get
        case post
        case put
        case patch
        case delete

        var spelled: String { rawValue.uppercased() }
    }
    
    protocol Endpoint {
        var baseUrl: String { get }
        var route: String { get }
        var method: Method { get }
        
        var headers: [String: String]? { get }
        var body: Data? { get }
        var queryParameters: [String: String]? { get }
        
        func createURL() throws -> URL
        func createRequest() throws -> URLRequest
    }
    
    typealias URLResponsePair = (data: Data, response: URLResponse)
    typealias URLResponsePublisher = AnyPublisher<URLResponsePair, URLError>
    
    // MARK: - Error Types
    
    enum EndpointError: Error {
        case malformedUrl
    }
    
    enum ClientError: Error {}

    // MARK: - Convenience Client
    
    struct Client {
        var session: URLSession = .shared
        
        // MARK: - Actual API performance hooks
        
        var fetchAsync: (URLSession, URLRequest) async throws -> URLResponsePair = { try await $0.data(for: $1) }
        var fetchPublisher: (URLSession, URLRequest) -> URLResponsePublisher = { $0.dataTaskPublisher(for: $1).eraseToAnyPublisher() }
        var fetchWithCompletion: (URLSession, URLRequest, @escaping (Data?, URLResponse?, Error?) -> Void) -> Void = { $0.dataTask(with: $1, completionHandler: $2) }
        
        // MARK: - Concurrency
        
        func request<S: Serializer>(fromEndpoint endpoint: Endpoint, 
                                    using serializer: S) async throws -> S.Model {
            let request = try endpoint.createRequest()
            print("Request: \(String(describing: request.url))")
            let (data, _) = try await fetchAsync(session, request)
            return try serializer.decode(data: data)
        }
        
        func request<Model: Decodable>(fromEndpoint endpoint: Endpoint) async throws -> Model {
            return try await request(fromEndpoint: endpoint, using: JSONSerializer<Model>())
        }
        
        // MARK: - Combine
        
        func endpoint<S: Serializer, M: Decodable>(_ endpoint: Endpoint,
                                                   using serializer: S)
        -> AnyPublisher<M, Error> where S.Model == M {
            do {
                let request = try endpoint.createRequest()
                return fetchPublisher(session, request)
                    .map(\.data)
                    .decode(using: serializer)
                    .eraseToAnyPublisher()
            } catch {
                return Fail<S.Model, Error>(error: error).eraseToAnyPublisher()
            }
        }
        
        func endpoint<M: Decodable>(_ endpoint: Endpoint)
            -> AnyPublisher<M, Error> { self.endpoint(endpoint, using: JSONSerializer<M>()) }
        
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

extension URL {
    var rfc1808Host: String? {
        guard let scheme = scheme, let host = host(percentEncoded: false) else { return nil }
        return "\(scheme)://\(host)"
    }
    
    var rfc1808BasedPath: String? {
        guard let hostPart = rfc1808Host else { return nil }
        return absoluteString.replacingOccurrences(of: hostPart, with: "")
    }
}

extension REST.Endpoint {
    var body: Data? { nil }
    var queryParameters: [String: String]? { nil }
    
    func createURL() throws -> URL {
        var urlComponents = URLComponents(string: baseUrl)
        urlComponents?.path = route
        urlComponents?.queryItems = queryParameters?.map(URLQueryItem.from)
        
        guard let url = urlComponents?.url else {
            throw REST.EndpointError.malformedUrl
        }
        
        print("Generated URL: \(url)")
        return url
    }
    
    func createRequest() throws -> URLRequest {
        var request = URLRequest(url: try createURL())
        request.httpMethod = method.spelled
        request.httpBody = body
        
        if let headers = headers {
            headers.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        }
        
        return request
    }
}
