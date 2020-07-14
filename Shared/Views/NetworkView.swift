//
//  TimelineView.swift
//  Codename Starlight
//
//  Created by Alejandro Modroño Vara on 10/07/2020.
//

import Foundation
import SwiftUI

struct NetworkView: View {

    @ObservedObject var timeline = NetworkViewModel()

    private let size: CGFloat = 300
    private let padding: CGFloat = 10
    private let displayPublic: Bool = true

    var body: some View {

        NavigationView {

            #if os(iOS)

            self.view
                .navigationTitle("Network")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing, content: {

                        Button(action: {}, label: {
                            Image(systemName: "line.horizontal.3.decrease")
                                .imageScale(.large)
                        })

                    })

                }

            #else

            self.view
                .navigationTitle("Network")
                .navigationSubtitle("\(Date())")

            #endif

        }
            .onAppear {
                self.timeline.fetchLocalTimeline()
            }

    }

    var view: some View {

        List {
            Section {
                NavigationLink(destination: Text("F").padding()) {
                    Label("Announcements", systemImage: "megaphone")
                }
                NavigationLink(destination: Text("F").padding()) {
                    Label("Activity", systemImage: "flame")
                }
            }
            .listStyle(InsetGroupedListStyle())

            Section(header:
                Picker(selection: self.$timeline.type, label: Text("Network visibility")) {
                    Text("My community").tag(TimelineScope.local)
                    Text("Public").tag(TimelineScope.public)
                }                        .pickerStyle(SegmentedPickerStyle())
                    .padding(.top)
                    .padding(.bottom, 2)) {

                if self.timeline.statuses.isEmpty {

                    HStack {

                        Spacer()

                        VStack {

                            Spacer()

                            ProgressView(value: 0.5)
                                .progressViewStyle(CircularProgressViewStyle())

                            Text("Loading posts...")

                            Spacer()

                        }

                        Spacer()

                    }

                } else {

                    ForEach(self.timeline.statuses, id: \.self.id) { status in
                        StatusView(status: status)
                            .buttonStyle(PlainButtonStyle())
                    }

                }
            }

        }
            .listStyle(GroupedListStyle())

    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
