//
//  PostListViewModel.swift
//  CIMBPost
//
//  Created by Phincon on 27/09/25.
//

import Foundation

@MainActor
final class PostListViewModel: ObservableObject {
    enum State: Equatable {
        case idle
        case loading
        case loaded([Post])
        case failed(String)
    }
    
    @Published private(set) var state: State = .idle
    @Published var searchText: String = ""
    
    private let repository: PostRepository
    private var allPosts: [Post] = []
    
    init(repository: PostRepository) {
        self.repository = repository
    }
    
    func load() async {
        state = .loading
        do {
            let posts = try await repository.getPosts()
            allPosts = posts
            state = .loaded(posts)
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? "Unexpected error"
            state = .failed(message)
        }
    }
    
    func retry() async { await load() }
    
    func filterPosts() {
        guard case .loaded = state else { return }
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            state = .loaded(allPosts)
        } else {
            let filtered = allPosts.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
            state = .loaded(filtered)
        }
    }
}
