//
//  Standard.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/8/20.
//

import SwiftUI

/// The navigation layout on bigger devices such as iPads and Macs.
struct StandardNavigationLayout: View {

    /// An enumeration of the different timeline pages
    enum NavigationViews {
        case home
        case local
        case `public`
        case messages
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

    /// The primary view.
    var body: some View {
        HStack {
            NavigationView {
                VStack {
                    #if os(macOS)
                    HStack {
                        TextField("Search...", text: self.$searchText)
                            .cornerRadius(4)
                    }
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onTapGesture {
                            self.selection = [.searchResults]
                        }
                    #endif

                    List(selection: $selection) {

                        Group {

                            NavigationLink(
                                destination:
                                    TimelineView()
                                        .padding()
                                        .frame(maxWidth: .infinity, maxHeight: .infinity),
                                label: {
                                    Label("Home", systemImage: "house")
                                })
                                .accessibility(label: Text("Home"))
                                .tag(NavigationViews.home)

                            NavigationLink(
                                destination:
                                    Text("Local timeline")
                                        .padding()
                                        .frame(maxWidth: .infinity, maxHeight: .infinity),
                                label: {
                                    Label("Local", systemImage: "building.2")
                                })
                                .accessibility(label: Text("Local"))
                                .tag(NavigationViews.local)

                            NavigationLink(
                                destination:
                                    Text("Public timeline")
                                        .padding()
                                        .frame(maxWidth: .infinity, maxHeight: .infinity),
                                label: {
                                    Label("Public", systemImage: "globe")
                                })
                                .accessibility(label: Text("Public"))
                                .tag(NavigationViews.public)

                            NavigationLink(
                                destination:
                                    Text("Messages")
                                        .padding()
                                        .frame(maxWidth: .infinity, maxHeight: .infinity),
                                label: {
                                    Label("Messages", systemImage: "quote.bubble")
                                })
                                .accessibility(label: Text("Messages"))
                                .tag(NavigationViews.messages)

                            #if os(iOS)
                            NavigationLink(
                                destination:
                                    Text("Search")
                                        .padding()
                                        .frame(maxWidth: .infinity, maxHeight: .infinity),
                                label: {
                                    Label("Search", systemImage: "magnifyingglass")
                                })
                                .accessibility(label: Text("Search"))
                                .tag(NavigationViews.searchResults)
                            #endif

                        }

                        Divider()

                        Group {

                            NavigationLink(
                                destination:
                                    Text("Announcements")
                                    .padding()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity),
                                label: {
                                    Label("Announcements", systemImage: "megaphone")
                                })
                                .accessibility(label: Text("Announcements"))
                                .tag(NavigationViews.announcements)

                            NavigationLink(
                                destination:
                                    Text("Activity")
                                    .padding()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity),
                                label: {
                                    Label("Activity", systemImage: "flame")
                                })
                                .accessibility(label: Text("Activity"))
                                .tag(NavigationViews.activity)

                            NavigationLink(
                                destination:
                                    Text("Recommended")
                                    .padding()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity),
                                label: {
                                    Label("Recommended", systemImage: "person.2")
                                })
                                .accessibility(label: Text("Recommended"))
                                .tag(NavigationViews.recommended)

                        }
                    }
                    .listStyle(SidebarListStyle())
                    .frame(minWidth: 170, maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(minWidth: 190, idealWidth: 200, maxWidth: .infinity, maxHeight: .infinity)
            }
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

    /// Change the current view selection to the notifications view.
    private func selectNotifications() {
        self.selection = [.notifications]
    }
}

struct Standard_Previews: PreviewProvider {
    static var previews: some View {
        StandardNavigationLayout()
    }
}
