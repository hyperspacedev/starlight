//
//  SettingsView.swift
//  SettingsView
//
//  Created by Marquis Kurt on 25/7/21.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: Text("Fediverse account settings")) {
                        ProfileCard()
                    }
                }
                
                Section {
                    NavigationLink("General") {
                        Text("General")
                    }
                    NavigationLink("Appearance") {
                        Text("Appearance")
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationBarTitle("tabs.prefs")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
