//
//  NetworkView.swift
//  NetworkView
//
//  Created by Marquis Kurt on 5/8/21.
//

import SwiftUI
import Chica

struct NetworkView: View {
    
    @State private var networkScope: TimelineNetworkScope = .local
    
    var body: some View {
        NavigationView {
            VStack {
                TimelineView(.network, with: networkScope) { }
            }
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker(selection: $networkScope, content: {
                        Label("network.local", systemImage: "person.3")
                            .tag(TimelineNetworkScope.local)
                        Label("network.federated", systemImage: "globe")
                            .tag(TimelineNetworkScope.federated)
                    }) {
                        Label("Scope", systemImage: "globe")
                    }
                }
            }
        }
    }
}

struct NetworkView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkView()
    }
}
