//
//  ContentView.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 6/23/20.
//

import Chica
import SwiftUI

/// The structured view for the app
struct ContentView: View {
    
    @ObservedObject private var OAuthManager: Chica.OAuth = Chica.OAuth.shared
    @Environment(\.deeplink) var deeplink

    #if os(iOS)
    /// Determines whether the device is compact or standard
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif

    var body: some View {
        Group {
            #if os(macOS)
            StandardNavigationLayout()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            #else
            switch self.OAuthManager.authState {
            case .authenthicated(_):
                if horizontalSizeClass == .compact {
                    CompactNavigationLayout()
                } else {
                    StandardNavigationLayout()
                }
            default:
                LoginView()
                    .environment(\.deeplink, self.deeplink)
            }
            #endif
        }
        .animation(.spring(), value: self.OAuthManager.authState)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
