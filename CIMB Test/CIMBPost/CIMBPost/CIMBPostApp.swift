//
//  CIMBPostApp.swift
//  CIMBPost
//
//  Created by Phincon on 27/09/25.
//

import SwiftUI

@main
struct PostsApp: App {
    var body: some Scene {
        WindowGroup {
            let httpClient = DefaultHTTPClient()
            let service = PostService(httpClient: httpClient)
            let repository = DefaultPostRepository(service: service)
            let vm = PostListViewModel(repository: repository)
            PostListView(viewModel: vm)
        }
    }
}
