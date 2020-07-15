//
//  HomeView.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/13/20.
//

import SwiftUI

struct HomeView: View {

    @State var showComposeButton: Bool = false

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
                    NavigationLink(
                        destination: NotificationsView()) {
                        Image(systemName: "bell")
                    }
                    .help("View all of your notifications.")
                }
                #endif
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showComposeButton = true
            }
        }
        .onDisappear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showComposeButton = false
            }
        }
        .overlay(
            self.composeButton
                .padding()
                .help("Create a new post."),
            alignment: .bottomTrailing)
    }

    var composeButton: some View {

        Button(action: {}, label: {
            Image(systemName: "square.and.pencil")
                .padding()
        })
            .foregroundColor(.white)
            .background(
                Circle()
                    .foregroundColor(.accentColor)
            )
            .offset(x: self.showComposeButton ? 0 : -99999)
            .animation(.spring())

    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
