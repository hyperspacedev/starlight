//
//  NotificationsView.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/14/20.
//

import SwiftUI

struct NotificationsView: View {
    
    @State var pageSelect: String = "notifs"
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                List {
                    Text("Notifications go here.")
                }
                .listStyle(GroupedListStyle())
            }
            .edgesIgnoringSafeArea(.top)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            #if os(iOS)
            ToolbarItem(placement: .principal) {
                Picker("Notification Types", selection: $pageSelect) {
                    Text("All").tag("notifs")
                    Text("Messages").tag("messages")
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            #endif
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            NotificationsView()
        }
    }
}
