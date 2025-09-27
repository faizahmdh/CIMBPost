//
//  PostListView.swift
//  CIMBPost
//
//  Created by Phincon on 27/09/25.
//

import SwiftUI

struct PostListView: View {
    @StateObject var viewModel: PostListViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                content
            }
            .navigationTitle("📚 Posts")
            .navigationBarTitleDisplayMode(.large)
            .toolbarTitleDisplayMode(.large)
            .font(.system(.largeTitle, design: .rounded).weight(.black))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task { await viewModel.load() }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .help("Reload posts")
                }
            }
        }
        .task { await viewModel.load() }
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
        .onChange(of: viewModel.searchText) {
            withAnimation(.easeInOut) {
                viewModel.filterPosts()
            }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            LoadingView()
                .transition(.opacity.combined(with: .scale))
        case .failed(let message):
            ErrorView(message: message) { await viewModel.retry() }
                .transition(.slide)
        case .loaded(let posts):
            if posts.isEmpty {
                ContentUnavailableView(
                    "No Results",
                    systemImage: "doc.text.magnifyingglass",
                    description: Text("Try a different keyword.")
                )
                .transition(.opacity)
            } else {
                CustomRefreshView(onRefresh: {
                    await viewModel.load()
                }) {
                    LazyVStack(spacing: 16) {
                        ForEach(posts) { post in
                            NavigationLink(value: post) {
                                PostRowView(post: post)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                }
                .navigationDestination(for: Post.self) { post in
                    PostDetailView(post: post)
                }
                .refreshable { await viewModel.load() }
            }
        }
    }
}

// MARK: - Custom Row
struct PostRowView: View {
    let post: Post
    
    // Dynamic gradient based on id
    private var gradientColors: [Color] {
        switch post.id % 3 {
        case 0: return [.blue.opacity(0.8), .purple.opacity(0.6)]
        case 1: return [.orange.opacity(0.8), .pink.opacity(0.6)]
        default: return [.green.opacity(0.8), .teal.opacity(0.6)]
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(post.title.capitalized)
                .font(.system(.title3, design: .rounded).weight(.semibold))
                .foregroundStyle(.primary)
                .lineLimit(2)
            
            Text(post.body)
                .font(.system(.subheadline, design: .serif))
                .foregroundStyle(.secondary)
                .lineLimit(3)
                .lineSpacing(4)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(colors: gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing)
                .opacity(0.15)
        )
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(LinearGradient(colors: gradientColors, startPoint: .leading, endPoint: .trailing), lineWidth: 1.2)
        )
        .contentShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview("PostListView - Loaded") {
    let samplePosts = [
        Post(id: 1, title: "SwiftUI Guide", body: "Learn to build modern iOS apps with SwiftUI."),
        Post(id: 2, title: "Kotlin Intro", body: "Cross-platform development made easier."),
        Post(id: 3, title: "Compose vs SwiftUI", body: "Compare Google Jetpack Compose with SwiftUI.")
    ]
    
    let vm = PostListViewModel(repository: MockPostRepository(posts: samplePosts))
    return PostListView(viewModel: vm)
}

final class MockPostRepository: PostRepository {
    private let stub: [Post]
    init(posts: [Post]) { self.stub = posts }
    
    func getPosts() async throws -> [Post] {
        return stub
    }
}
