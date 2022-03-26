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
        NavigationView {
            StylableScrollView(.vertical, showIndicators: false) {
                TimelineScrollViewCompatible(scope: .network(localOnly: networkScope == .local))
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

                    },
                    leadingElements: { _ in EmptyView() },
                    trailingElements: { _ in EmptyView() }
                )
            )
        }
    }
    
    var networkPicker: some View {
        Picker("Select", selection: $networkScope) {
            Label("network.local", systemImage: "person.2")
                .tag(TimelineNetworkScope.local)
            Label("network.federated", systemImage: "globe")
                .tag(TimelineNetworkScope.federated)
        }
        .pickerStyle(.menu)
    }
}

struct NetworkView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkView()
    }
}
