//
//  Trending.swift
//  Trending
//
//  Created by Marquis Kurt on 25/7/21.
//

import SwiftUI
import Chica

/// A view that represents a list of trending hashtags.
///
/// This is best placed in an existing `List` view.
struct TrendingList: View {
    
    /// The list of tags that will be rendered.
    var trends: [Tag] = []
    
    /// The number of tags from the list to display.
    var limit: Int?
    
    private var _limit: Int {
        limit ?? (trends.isEmpty ? 5 : trends.count)
    }
    
    /// The main content for this view.
    var body: some View {
        Section(header: Text("explore.trends")) {
            ForEach(0..<_limit) { idx in
                if trends.isEmpty {
                    Label("Tag goes here", systemImage: "number")
                        .redacted(reason: .placeholder)
                } else {
                    NavigationLink(destination: TrendingDetail(tag: self.trends[idx])) {
                        Label("\(self.trends[idx].name)", systemImage: "tag")
                    }
                }
                
            }
        }
    }
}

/// A view that represents a detail for a trending tag.
struct TrendingDetail: View {
    
    /// The tag to view details of.
    @State var tag: Tag
    
    @State var timeline: [Status]? = []
    
    var body: some View {
        ScrollView {
            #if os(iOS)
            header
            #endif
            
            TimelineView(.tag(tag: tag.name)) { }

        }
        .listStyle(.plain)
        .navigationTitle("#\(tag.name)")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #else
        .navigationSubtitle(
            String(
                format: NSLocalizedString("explore.trends.tagline", comment: "Explore tagline"),
                "\(getAccountsUsingTag())", "\(getUsesForToday())")
        )
        #endif
    }
    
    var header: some View {
        HStack(alignment: .firstTextBaseline) {
            Image(systemName: "tag")
                .foregroundColor(.secondary)
            VStack(alignment: .leading) {
                Text(tag.name)
                    .font(.system(.title, design: .rounded))
                    .bold()
                Text(
                    String(
                        format: NSLocalizedString("explore.trends.tagline.accounts", comment: "Explore accounts"),
                        "\(getAccountsUsingTag())"
                    )
                )
                Text(
                    String(
                        format: NSLocalizedString("explore.trends.tagline.uses", comment: "Explore uses"),
                        "\(getUsesForToday())"
                    )
                )
            }
        }
    }
    
    /// Returns the number of people talking about this particular topic within the past 24 hours.
    func getAccountsUsingTag() -> Int { Int(tag.history?.first?.accounts ?? "0") ?? 0 }
    
    /// Returns the number of posts using this tag within the past 24 hours.
    func getUsesForToday() -> Int { Int(tag.history?.first?.uses ?? "0") ?? 0 }
    
}

struct TrendingList_Previews: PreviewProvider {
    static var previews: some View {
        TrendingList()
    }
}
