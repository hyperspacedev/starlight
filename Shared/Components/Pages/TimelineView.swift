//
//  TimelineView.swift
//  TimelineView
//
//  Created by Marquis Kurt on 26/7/21.
//

import SwiftUI
import Chica

/// A view that displays a timeline of posts.
struct TimelineView: View {
    
    enum Timeline {
        case home
        case local
        case `public`
    }
    
    @State private var posts: [Status]? = []
    @State var timeline: Timeline = .home
    
    var body: some View {
        VStack {
            if posts == nil {
                Text("misc.placeholder")
            } else {
                List(posts ?? [], id: \.self) { status in
                    Text(status.content.toMarkdown())
                        .padding()
                        .border(.selection, width: 1)
                }
            }

        }
        .onAppear(perform: loadData)
        .refreshable(action: loadData)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func loadData() {
        Task.init { try await fetchPostsFromTimeline() }
    }
    
    
    private func fetchPostsFromTimeline() async throws {
        // TODO: Implement the proper timeline networking requests here.
        switch timeline {
        case .home:
            posts = []
        case .local:
            posts = []
        case .public:
            posts = []
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
    }
}
