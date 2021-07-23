//
//  ContentView.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 6/23/20.
//

import SwiftUI

/// The structured view for the app
struct ContentView: View {

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
            LoginView()
//            if horizontalSizeClass == .compact {
//                CompactNavigationLayout()
//            } else {
//                StandardNavigationLayout()
//            }
            #endif
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
