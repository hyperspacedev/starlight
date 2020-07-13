//
//  HomeView.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/13/20.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            List {
                Text("Statuses goes here")
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Home")
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {}) {
                        Image(systemName: "square.and.pencil")
                    }
                    .help("Create a new post.")
                }
                #endif
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
