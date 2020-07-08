//
//  Standard.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/8/20.
//

import SwiftUI

struct StandardNavigationLayout: View {
    var body: some View {
        HStack {
            NavigationView {
                VStack(alignment: .leading) {
                    List {
                        NavigationLink(
                            destination:
                                /*@START_MENU_TOKEN@*/Text("Destination")/*@END_MENU_TOKEN@*/.padding(),
                            label: {
                                Label("Home", systemImage: "house")
                            })
                        Text("G")
                    }.listStyle(SidebarListStyle())
                }
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
