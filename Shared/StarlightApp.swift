//
//  StarlightApp.swift
//  Shared
//
//  Created by Marquis Kurt on 6/23/20.
//

import SwiftUI
import Chica

@main
struct StarlightApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    // TODO: Add different URL endpoints here for deep linking.
                    // Maybe like Apollo?
                    Chica.handleURL(url: url, actions: [:])
                }
        }
        
        #if os(macOS)
        Settings {
            NavigationView {
                SettingsView()
            }
        }
        #endif
    }
}
