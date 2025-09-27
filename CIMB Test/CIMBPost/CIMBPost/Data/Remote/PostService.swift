//
//  PostService.swift
//  CIMBPost
//
//  Created by Phincon on 27/09/25.
//

import Foundation

protocol PostServiceProtocol {
    func fetchPosts() async throws -> [Post]
}

enum NetworkError: LocalizedError, Equatable {
    case invalidStatusCode(Int)
    case decodingFailed
    case transport(URLError)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidStatusCode(let code): return "Server returned status code: \(code)"
        case .decodingFailed: return "Failed to decode response"
        case .transport(let e): return e.localizedDescription
        case .unknown(let e): return e.localizedDescription
        }
    }

    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidStatusCode(let a), .invalidStatusCode(let b)):
            return a == b
        case (.decodingFailed, .decodingFailed):
            return true
        case (.transport(let a), .transport(let b)):
            return a.code == b.code
        case (.unknown, .unknown):
            return true
        default:
            return false
        }
    }
}

final class PostService: PostServiceProtocol {
    private let httpClient: HTTPClient
    init(httpClient: HTTPClient) { self.httpClient = httpClient }
    
    func fetchPosts() async throws -> [Post] {
        let request = PostAPI.list.request
        do {
            let (data, response) = try await httpClient.data(for: request)
            guard let http = response as? HTTPURLResponse else { throw NetworkError.decodingFailed }
            guard (200..<300).contains(http.statusCode) else { throw NetworkError.invalidStatusCode(http.statusCode) }
            do {
                return try JSONDecoder().decode([Post].self, from: data)
            } catch {
                throw NetworkError.decodingFailed
            }
        } catch {
            if let urlErr = error as? URLError { throw NetworkError.transport(urlErr) }
            if let netErr = error as? NetworkError { throw netErr }
            throw NetworkError.unknown(error)
        }
    }
}
