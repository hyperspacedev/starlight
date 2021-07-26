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
                TrendingList(trends: trendingTags)
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
        .autocapitalization(.none)
        .onAppear(perform: loadData)
        .refreshable(action: loadData)
    }
    
    var searchBar: some View {
        HStack {
            TextField("explore.search", text: $query)
                .autocapitalization(.none)
                .textFieldStyle(.roundedBorder)
            if !query.isEmpty {
                Button(action: {
                    query = ""
                }) {
                    Image(systemName: "delete.left")
                        .foregroundColor(.secondary)
                }
            }
        }
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
