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
                HomeView()
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
//                ProfileView(editable: true)
                ProfileView()
            }
            .tabItem {
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
        }
            .tabViewStyle(DefaultTabViewStyle())
            .overlay(noConnectionBanner, alignment: .top)
    }

    var noConnectionBanner: some View {
        VStack {
            if !isConnectedToNetwork() {
                HStack {

                    Spacer()

                    Text("No internet connection was found.")

                    Spacer()

                }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        Color.red
                    )
            }
        }.edgesIgnoringSafeArea(.top)
    }
}

struct Compact_Previews: PreviewProvider {
    static var previews: some View {
        AppTabNavigation()
    }
}
