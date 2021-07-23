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
                    Chica.handleURL(url: url)
                }
        }
    }
}
