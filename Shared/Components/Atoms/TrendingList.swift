//
//  Trending.swift
//  Trending
//
//  Created by Marquis Kurt on 25/7/21.
//

import SwiftUI
import Chica

struct TrendingList: View {
    
    var trends: [Tag]?
    
    var body: some View {
        Section(header: Text("explore.trends")) {
            if trends == nil {
                ForEach(1..<6) { _ in
                    Label("Tag goes here", systemImage: "number")
                        .redacted(reason: .placeholder)
                }
            } else {
                ForEach(trends ?? []) { tag in
                    NavigationLink(destination:
                                    Text("Posts with #\(tag.name)").padding()
                    ) {
                        Label("\(tag.name)", systemImage: "number")
                    }
                }
            }
        }
    }
}

struct TrendingList_Previews: PreviewProvider {
    static var previews: some View {
        TrendingList()
    }
}
