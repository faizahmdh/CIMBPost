//
//  PostRepository.swift
//  CIMBPost
//
//  Created by Phincon on 27/09/25.
//

import Foundation

protocol PostRepository {
    func getPosts() async throws -> [Post]
}

final class DefaultPostRepository: PostRepository {
    private let service: PostServiceProtocol
    init(service: PostServiceProtocol) { self.service = service }
    
    func getPosts() async throws -> [Post] {
        try await service.fetchPosts()
    }
}
