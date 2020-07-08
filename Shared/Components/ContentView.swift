//
//  ContentView.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 6/23/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Group {
            #if os(macOS)
            StandardNavigationLayout()
                .frame(minWidth: 500, minHeight: 300)
            #endif
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
