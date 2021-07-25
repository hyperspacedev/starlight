//
//  Trending.swift
//  Trending
//
//  Created by Marquis Kurt on 25/7/21.
//

import SwiftUI
import Chica

struct TrendingList: View {
    
    @State private var trends: [Tag]?
    
    var body: some View {
        List {
            Section("explore.trends") {
                ForEach(trends ?? []) { tag in
                    NavigationLink(destination:
                                    Text("Posts with #\(tag.name)").padding()
                    ) {
                        Label("\(tag.name)", systemImage: "number")
                    }
                }
            }
        }
        .refreshable {
            Task.init {
                try await getTrends()
            }
        }
        .onAppear {
            Task.init {
                try await getTrends()
            }
        }
    }
    
    func getTrends() async throws {
        trends = try await Chica.shared.request(.get, for: .trending)
    }
}

struct TrendingList_Previews: PreviewProvider {
    static var previews: some View {
        TrendingList()
    }
}
