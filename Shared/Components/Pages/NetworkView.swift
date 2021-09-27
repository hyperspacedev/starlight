//
//  NetworkView.swift
//  NetworkView
//
//  Created by Marquis Kurt on 5/8/21.
//

import SwiftUI
import Chica
import StylableScrollView

struct NetworkView: View {
    
    @State private var networkScope: TimelineNetworkScope = .local
    
    var body: some View {
        StylableScrollView(.vertical) {
            
            // FIXME: For some reason, this timeline seems to be disabled. I have no clue why. - @alicerunsonfedora
            TimelineScrollViewCompatible(timeline: .network, localOnly: networkScope == .local)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal)
        }
        .scrollViewStyle(
            StretchableScrollViewStyle(
                header: {
                    Color.white
                },
                title: {
                    HStack {
                        Text("tabs.network")
                            .font(.system(.title, design: .rounded))
                            .bold()
                        Spacer()
                        networkPicker
                    }
                    .padding(.horizontal)

                },
                navBarContent: {
                    HStack {
                        Text("tabs.network")
                            .font(.system(.title2, design: .rounded))
                            .bold()
                        Spacer()
                        networkPicker
                    }
                    .padding(.horizontal)

                }
            )
        )
    }
    
    var networkPicker: some View {
        Picker("", selection: $networkScope) {
            Label("network.local", systemImage: "person.2")
                .tag(TimelineNetworkScope.local)
            Label("network.federated", systemImage: "globe")
                .tag(TimelineNetworkScope.federated)
        }
        .pickerStyle(.menu)
        .foregroundColor(.white)
    }
}

struct NetworkView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkView()
    }
}
