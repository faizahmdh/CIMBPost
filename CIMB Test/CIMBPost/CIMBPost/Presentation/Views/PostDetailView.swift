//
//  PostDetailView.swift
//  CIMBPost
//
//  Created by Phincon on 27/09/25.
//

import SwiftUI

struct PostDetailView: View {
    let post: Post
    @State private var animate = false
    
    private var gradientColors: [Color] {
        switch post.id % 3 {
        case 0: return [.blue.opacity(0.8), .purple.opacity(0.6)]
        case 1: return [.orange.opacity(0.8), .pink.opacity(0.6)]
        default: return [.green.opacity(0.8), .teal.opacity(0.6)]
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // HEADER
                ZStack {
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 220)
                    .overlay(
                        Image(systemName: "doc.text.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                            .foregroundStyle(.white.opacity(0.15))
                            .rotationEffect(.degrees(animate ? 8 : -8))
                            .offset(x: animate ? 25 : -25, y: 25)
                            .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: animate)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding(.horizontal)
                }
                .onAppear { animate = true }
                
                // TITLE
                Text(post.title.capitalized)
                    .font(.system(.title, design: .rounded).weight(.bold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .shadow(radius: 2)
                
                // BODY CONTENT CARD
                VStack(alignment: .leading, spacing: 16) {
                    Text("✨ Post Content")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    // BODY
                    Text(post.body)
                        .font(.system(.body, design: .serif))
                        .foregroundStyle(.primary)
                        .lineSpacing(6)
                        .padding(.horizontal)
                    
                    Divider()
                        .overlay(LinearGradient(colors: gradientColors, startPoint: .leading, endPoint: .trailing))
                    
                    Text("ID: \(post.id)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                        .shadow(radius: 2)
                )
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview("PostDetailView - Sample") {
    let samplePost = Post(
        id: 1,
        title: "SwiftUI Guide",
        body: "Learn to build modern iOS apps with SwiftUI."
    )
    return NavigationStack {
        PostDetailView(post: samplePost)
    }
}


