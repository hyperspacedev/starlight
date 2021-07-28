//
//  SettingsView.swift
//  SettingsView
//
//  Created by Marquis Kurt on 25/7/21.
//

import SwiftUI

/// The main view for adjusting settings.
struct SettingsView: View {
    
    private enum SettingsKeys {
        case account
        case general
        case appearance
    }
    
    @State private var selection: Set<SettingsKeys> = [.general]
    
    var body: some View {
        NavigationView {
            List(selection: $selection) {
                NavigationLink(destination: Text("Fediverse account settings").navigationTitle("Fediverse Account")) {
                    #if os(iOS)
                    ProfileCard(imageSize: .medium)
                    #else
                    ProfileCard(imageSize: .small)
                    #endif
                }
                .tag(SettingsKeys.account)
                
                Section {
                    NavigationLink(destination: Text("General").navigationTitle("General")) {
                        Label("General", systemImage: "gear")
                    }
                    .tag(SettingsKeys.general)
                    NavigationLink(destination: Text("Appearance").navigationTitle("Appearance")) {
                        Label("Appearance", systemImage: "paintbrush")
                    }
                    .tag(SettingsKeys.appearance)
                }
                #if os(macOS)
                .collapsible(false)
                #endif
            }
            #if os(iOS)
            .listStyle(.insetGrouped)
            .navigationBarTitle("tabs.prefs")
            #elseif os(macOS)
            .listStyle(.sidebar)
            #endif
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
