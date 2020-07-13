//
//  ExploreView.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/12/20.
//

import SwiftUI

struct ExploreView: View {

    @State private var searchText: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                List {
                    Section {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            TextField("Search...", text: $searchText)
                        }
                    }
                    Section(header: Text("Trending Hashtags")) {
                        Label("equestria", systemImage: "number")
                        Label("mastodon", systemImage: "number")
                    }
                    Section(header: Text("Recommended")) {
                        RecommendedProfile(imageName: "amethyst", name: "Amethyst", user: "@amethyst")
                        RecommendedProfile(imageName: "curtis", name: "Curtis Smith", user: "@asalways")
                        RecommendedProfile(imageName: "pointFlash", name: "Point Flash", user: "@iamnotabug")
                        RecommendedProfile(imageName: "amodrono", name: "amodrono", user: "@amodrono")
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("Explore")
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            NavigationView {
                ExploreView()
            }
            .tabItem {
                Label("Explore", systemImage: "magnifyingglass")
            }
        }
    }
}
