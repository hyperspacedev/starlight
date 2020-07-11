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
    /// Determines whether the device is compact (iOS) or standard (iPadOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif

    var body: some View {
        Group {

            #if os(macOS)

            StandardNavigationLayout()
                .frame(maxWidth: .infinity, idealHeight: 600, maxHeight: .infinity)

            #else

            if horizontalSizeClass == .compact {

                AppTabNavigation()

            } else {

                StandardNavigationLayout()

            }

            #endif
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
