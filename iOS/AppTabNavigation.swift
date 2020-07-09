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
                TimelineView()
            }.tabItem {
                Label("Home", systemImage: "house")
            }
            VStack {
                Text("Network View")
                    .padding()
            }.tabItem {
                Label("Network", systemImage: "network")
            }
            VStack {
                Text("Explore View")
                    .padding()
            }.tabItem {
                Label("Explore", systemImage: "magnifyingglass")
            }
            VStack {
                Text("Personal View")
                    .padding()
            }.tabItem {
                Label("You", systemImage: "person.circle")
            }
            VStack {
                Text("Settings View")
                    .padding()
            }.tabItem {
                Label("Settings", systemImage: "gear")
            }
        }.tabViewStyle(DefaultTabViewStyle())
    }
}

struct Compact_Previews: PreviewProvider {
    static var previews: some View {
        AppTabNavigation()
    }
}
