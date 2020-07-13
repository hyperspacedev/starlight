//
//  Compact.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/8/20.
//

import SwiftUI

/// This navigation layout will be used when the device is running on iOS with compact mode (i.e. iPhones and iPods).
struct AppTabNavigation: View {
    var body: some View {
        TabView {
            VStack {
                Text("Home")
                    .padding()
            }.tabItem {
                Label("Home", systemImage: "house")
                    .imageScale(.large)
            }
            VStack {
                NetworkView()
            }.tabItem {
                Label("Network", systemImage: "network")
                    .imageScale(.large)
            }
            VStack {
                ExploreView()
            }.tabItem {
                Label("Explore", systemImage: "magnifyingglass")
                    .imageScale(.large)
            }
            VStack {
                Text("Personal View")
                    .padding()
            }.tabItem {
                Label("You", systemImage: "person.circle")
                    .imageScale(.large)
            }
            VStack {
                Text("Settings View")
                    .padding()
            }.tabItem {
                Label("Settings", systemImage: "gear")
                    .imageScale(.large)
            }
        }.tabViewStyle(DefaultTabViewStyle())
    }
}

struct Compact_Previews: PreviewProvider {
    static var previews: some View {
        AppTabNavigation()
    }
}
