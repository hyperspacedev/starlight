//
//  ExploreView.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/12/20.
//

import SwiftUI

struct ExploreView: View {

    @State private var searchText: String = ""
    @ObservedObject private var explored = ExploreViewModel()

    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            TextField("Search...", text: $searchText)
                        }
                    }

                    if !self.explored.tags.isEmpty {
                        Section(header: Text("Trending Tags")) {

                            ForEach(self.explored.tags, id: \.self.id) { (tag: Tag) in
                                HStack(spacing: 20) {
                                    Image(systemName: "number")
                                        .foregroundColor(.accentColor)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("\(tag.name)")
                                        Text("\(tag.history?.first?.accounts ?? "0") people talking")
                                            .font(.caption)
                                    }
                                }
                                .padding(.horizontal, 5)
                            }
                        }
                    }

                    Section(header: Text("Recommended for You")) {
                        RecommendedProfile(imageName: "amethyst", name: "Amethyst", user: "@amethyst")
                        RecommendedProfile(imageName: "curtis", name: "Curtis Smith", user: "@asalways")
                        RecommendedProfile(imageName: "pointFlash", name: "Point Flash", user: "@iamnotabug")
                        NavigationLink(destination: RecommendedView()) {
                            Label("All Recommendations", systemImage: "person.2")
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("Explore")
            .onAppear {
                self.explored.getTags()
            }
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            ExploreView()
            .tabItem {
                Label("Explore", systemImage: "magnifyingglass")
            }
        }
    }
}
