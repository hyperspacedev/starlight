//
//  ExploreView.swift
//  ExploreView
//
//  Created by Marquis Kurt on 26/7/21.
//

import SwiftUI
import Chica

struct ExploreView: View {
    @State private var query: String = ""
    @State private var trendingTags: [Tag]?
    
    var body: some View {
        NavigationView {
            List {
                TrendingList(trends: trendingTags ?? [])
            }
            .navigationTitle("tabs.explore")
        }
        .searchable(text: $query, prompt: "explore.search", suggestions: {
            if !query.isEmpty {
                Text("@\(query)")
                    .searchCompletion("@\(query)")
                Text("#\(query)")
                    .searchCompletion("#\(query)")
            }
        })
        #if os(iOS)
        .autocapitalization(.none)
        #endif
        .onAppear(perform: loadData)
        .refreshable(action: loadData)
    }
    
    func loadData() {
        Task.init {
            try await getTrends()
        }
    }
    
    func getTrends() async throws {
        trendingTags = try await Chica.shared.request(.get, for: .trending)
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
