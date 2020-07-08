//
//  Standard.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/8/20.
//

import SwiftUI

/// The navigation layout on bigger devices such as iPads and Macs.
struct StandardNavigationLayout: View {

    /// The search bar's current text input.
    @State private var searchText = ""

    /// The primary view.
    var body: some View {
        HStack {
            NavigationView {
                VStack(alignment: .leading) {

                    #if os(macOS)
                    TextField("Search...", text: $searchText)
                        .padding(.horizontal)
                        .cornerRadius(4)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    #endif

                    List {
                        NavigationLink(
                            destination:
                                Text("Home timeline")
                                    .padding()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity),
                            label: {
                                Label("Home", systemImage: "house")
                            })
                        NavigationLink(
                            destination:
                                Text("Local timeline")
                                    .padding()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity),
                            label: {
                                Label("Local", systemImage: "building.2")
                            })
                        NavigationLink(
                            destination:
                                Text("Public timeline")
                                    .padding()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity),
                            label: {
                                Label("Public", systemImage: "globe")
                            })
                    }
                    .listStyle(SidebarListStyle())
                    .frame(maxWidth: .infinity)
                }
                .frame(minWidth: 170, idealWidth: 180, maxWidth: .infinity)
            }
            .toolbar {
                #if os(macOS)
                ToolbarItem(placement: .navigation) {
                    Button(action: toggleSidebar) {
                        Image(systemName: "sidebar.left")
                    }
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
}

struct Standard_Previews: PreviewProvider {
    static var previews: some View {
        StandardNavigationLayout()
    }
}
