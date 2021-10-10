//
//  NotificationsView.swift
//  Starlight
//
//  Created by Marquis Kurt on 10/10/21.
//

import SwiftUI
import Chica
import class Chica.Notification     // Fixes type ambiguity by force-importing the Notification class.

/// A view that displays the user's notifcations.
struct NotificationsView: View, InternalStateRepresentable {
    
    @State private var showClearAlert: Bool = false
    @State private var notifications: [Notification]? = []
    @State internal var state = ViewState.initial
    
    /// The main body for the view.
    var body: some View {
        NavigationView {
            VStack {
                switch state {
                case .initial, .loading:
                    ProgressView()
                        .padding()
                case .loaded, .updated:
                    if let notifs = notifications {
                        if notifs.isEmpty { emptyNotifs }
                        else {
                            // FIXME: Replace placeholder with notification children views.
                            VStack {
                                Text("misc.placeholder")
                                Text("\(notifs.count)")
                            }
                        }

                    } else {
                        emptyNotifs
                    }
                case .errored(let reason):
                    StackedLabel(image: Image(systemName: "trash"), title: "notifications.errored") {
                        VStack {
                            Text(reason)
                            Button(action: { loadData() }) {
                                Text("actions.reload")
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }
                
                
                
                

            }
            .padding()
            .navigationTitle("tabs.notifs")
            .onAppear { loadData() }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showClearAlert = true }) {
                        Label("actions.clearall", systemImage: "trash")
                            .symbolRenderingMode(.multicolor)
                    }
                    .alert("notifs.clear", isPresented: $showClearAlert, actions: {
                        Button("actions.clearall", role: .destructive) { }
                        Button("actions.cancel", role: .cancel) { }
                    }, message: {
                        Text("notifs.clear.prompt")
                    })
                    .disabled(true)
                    .opacity(0.3)
                }
            }
        }
    }
    
    /// The view that is displayed when the notification list is empty.
    private var emptyNotifs: some View {
        StackedLabel(image: Image(systemName: "tray.fill"), title: "notifs.empty") {
            VStack {
                Text("notifs.empty.prompt")
                Button(action: {}) {
                    Text("actions.create")
                }
                .buttonStyle(.bordered)
            }

        }
    }
    
    /// Loads the list of notifications.
    internal func loadData() {
        state = .loading
        // FIXME: Implement this method.
        print("Not implemented.")
        notifications = []
        state = .loaded
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
