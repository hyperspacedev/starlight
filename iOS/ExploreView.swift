//
//  ExploreView.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/12/20.
//

import SwiftUI
import SwiftlySearch

struct ExploreView: View {

    @State private var searchText: String = ""
    @ObservedObject private var explored = ExploreViewModel()

    let results = [
        "amodrono",
        "pointFlash",
        "curtis",
        "amethyst"
    ]

    @State var isSearching: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                List {

                    if searchText == "" {
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

                    if searchText != "" {

                        Section(header: Text("Actions")) {
                            NavigationLink(destination: Text("Hello"), label: {
                                Label("Go to user @\(self.searchText)", systemImage: "person.2")
                            })
                            NavigationLink(destination: Text("Hello"), label: {
                                Label("Go to posts with \"\(self.searchText)\"", systemImage: "doc.richtext")
                            })
                        }

                        Section {
                            ForEach(self.results.filter {
                                        $0.localizedStandardContains(searchText)
                            }, id: \.self) { result in
                                RecommendedProfile(imageName: result, name: result, user: "@\(result)")
                            }
                        }

                    }

                }
                .listStyle(InsetGroupedListStyle())
            }
            .animation(.spring())
            .navigationTitle("Explore")
            .navigationBarHidden(self.isSearching)
            .navigationBarSearch(self.$searchText,
                                 placeholder: "Surf the fediverse")
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
