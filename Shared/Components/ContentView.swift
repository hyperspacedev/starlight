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
                .frame(minWidth: 500, minHeight: 300)
            #else
            if horizontalSizeClass == .compact {

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
