//
//  Standard.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/8/20.
//

import SwiftUI
import Chica

/// The navigation layout on bigger devices such as iPads and Macs.
struct StandardNavigationLayout: View {

    /// An enumeration of the different timeline pages
    enum NavigationViews {
        case home
        case network
        case messages
        case explore
        case announcements
        case activity
        case recommended
        case searchResults
        case notifications
    }

    /// The search bar's current text input.
    @State private var searchText = ""

    /// The current navigation selection
    @State private var selection: Set<NavigationViews> = [.home]
    
    /// Whether the user is logged out or not.
    @State private var loggedOut = Chica.OAuth.shared.authState == .signedOut
    
    @State private var trends: [Tag]?

    /// The primary view.
    var body: some View {
        HStack {
            NavigationView {
                VStack {
                    List(selection: $selection) {
                        NavigationLink(destination: TimelineView(.home){ }) {
                            Label("tabs.home", systemImage: "house")
                        }
                        .tag(NavigationViews.home)
                        NavigationLink(destination: TimelineView(.local){ }) {
                            Label("tabs.network", systemImage: "network")
                        }
                        .tag(NavigationViews.network)
                        NavigationLink(destination: Text("Messages").navigationTitle("Messages")) {
                            Label("Messages", systemImage: "bubble.left")
                        }
                        .tag(NavigationViews.messages)

                        TrendingList(trends: trends ?? [], limit: 5)
                        
                        #if os(iOS)
                        NavigationLink(destination: SettingsView()) {
                            Label("tabs.prefs", systemImage: "gear")
                        }
                        #endif
                    }
                    .listStyle(.sidebar)
                    .frame(minWidth: 170, maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(minWidth: 170, idealWidth: 180, maxWidth: .infinity, maxHeight: .infinity)
            }
            .onAppear(perform: loadData)
            .refreshable(action: loadData)
            .sheet(isPresented: $loggedOut) {
                LoginView()
                #if os(macOS)
                    .frame(width: 350, height: 500)
                #endif
            }
            .searchable(text: $searchText, prompt: "explore.search", suggestions: {
                if !searchText.isEmpty {
                    Text("@\(searchText)")
                        .searchCompletion("@\(searchText)")
                    Text("#\(searchText)")
                        .searchCompletion("#\(searchText)")
                }
            })
            .toolbar {
                #if os(macOS)
                ToolbarItem(placement: .navigation) {
                    Button(action: toggleSidebar) {
                        Image(systemName: "sidebar.left")
                    }.help("Show or hide the sidebar.")
                }
                ToolbarItem {
                    Button(action: selectNotifications) {
                        Image(systemName: "bell")
                    }
                    .help("View your notifications.")
                }

                ToolbarItem {
                    Button(action: selectNotifications) {
                        Image(systemName: "square.and.pencil")
                    }.help("Write a new post.")
                }
                #endif
            }
        }
    }

    /// Toggle the sidebar in macOS.
    private func toggleSidebar() {
        #if os(macOS)
        NSApp.keyWindow?.firstResponder?.tryToPerform(
            #selector(
                NSSplitViewController.toggleSidebar(_:)
            ), with: nil)
        #endif
    }
    
    private func refresh() {
        print("Refreshed!")
    }

    /// Change the current view selection to the notifications view.
    private func selectNotifications() {
        self.selection = [.notifications]
    }
    
    private func loadData() {
        Task.init {
            trends = try await Chica.shared.request(.get, for: .trending)
        }
    }
}

struct Standard_Previews: PreviewProvider {
    static var previews: some View {
        StandardNavigationLayout()
    }
}
