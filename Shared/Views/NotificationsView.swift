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
            VStack {
                Picker("Notification Types", selection: $pageSelect) {
                    Text("Announcements").tag("announces")
                    Text("Activity").tag("notifs")
                    Text("Messages").tag("messages")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                List {
                    Text("Notifications go here.")
                }
                .listStyle(GroupedListStyle())
            }
            .navigationTitle("Notifications")
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            NotificationsView()
        }
    }
}
