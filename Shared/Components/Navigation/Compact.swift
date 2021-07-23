//
//  Compact.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/8/20.
//

import SwiftUI

struct CompactNavigationLayout: View {
    var body: some View {
        TabView {
            VStack {
                Text("Home Feed View")
                    .padding()
            }.tabItem {
                Label("tabs.home", systemImage: "house")
            }
            VStack {
                Text("Network View")
                    .padding()
            }.tabItem {
                Label("tabs.network", systemImage: "network")
            }
            VStack {
                Text("Explore View")
                    .padding()
            }.tabItem {
                Label("tabs.explore", systemImage: "magnifyingglass")
            }
            VStack {
                Text("Personal View")
                    .padding()
            }.tabItem {
                Label("tabs.profile", systemImage: "person.circle")
            }
            VStack {
                Text("Settings View")
                    .padding()
            }.tabItem {
                Label("tabs.prefs", systemImage: "gear")
            }
        }.tabViewStyle(DefaultTabViewStyle())
    }
}

struct Compact_Previews: PreviewProvider {
    static var previews: some View {
        CompactNavigationLayout()
    }
}
