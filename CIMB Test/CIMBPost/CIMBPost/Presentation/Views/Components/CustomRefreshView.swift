//
//  CustomRefreshView.swift
//  CIMBPost
//
//  Created by Phincon on 27/09/25.
//

import SwiftUI

struct CustomRefreshView<Content: View>: View {
    @State private var isRefreshing = false
    @State private var progress: CGFloat = 0
    let threshold: CGFloat = 80
    let onRefresh: () async -> Void
    let content: () -> Content
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .top) {
                // Tracker offset
                GeometryReader { geo in
                    Color.clear
                        .preference(
                            key: ScrollOffsetPreferenceKey.self,
                            value: geo.frame(in: .named("refreshArea")).minY
                        )
                }
                .frame(height: 0)
                
                VStack(spacing: 0) {
                    // Custom colorful progress bar
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple, .pink],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 6)
                        .frame(maxWidth: UIScreen.main.bounds.width * progress)
                        .opacity(progress > 0 ? 1 : 0)
                        .animation(
                            .spring(response: 0.3, dampingFraction: 0.7),
                            value: progress
                        )
                    
                    content()
                }
            }
        }
        .coordinateSpace(name: "refreshArea")
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
            Task { @MainActor in
                let pull = max(0, min(offset / threshold, 1))
                
                if !isRefreshing {
                    if abs(progress - pull) > 0.01 {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            progress = pull
                        }
                    }
                }
                
                if pull >= 1, !isRefreshing {
                    triggerRefresh()
                }
            }
        }
    }
    
    @MainActor
    private func triggerRefresh() {
        isRefreshing = true
        Task {
            await onRefresh()
            await MainActor.run {
                withAnimation(.easeInOut) {
                    isRefreshing = false
                    progress = 0
                }
            }
        }
    }
}

