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
        TimelineMasterDetailView(timeline: .network, localOnly: networkScope == .local)
            .toolbar {
                ToolbarItem {
                    Picker("", selection: $networkScope) {
                        Label("network.local", systemImage: "person.2")
                            .tag(TimelineNetworkScope.local)
                        Label("network.federated", systemImage: "globe")
                            .tag(TimelineNetworkScope.federated)
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
