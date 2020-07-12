//
//  TimelineView.swift
//  Codename Starlight
//
//  Created by Alejandro Modroño Vara on 10/07/2020.
//

import Foundation
import SwiftUI

struct NetworkView: View {

    @ObservedObject var timeline = TimelineViewModel()

    @State var timelineType: String = "public"

    private let size: CGFloat = 300
    private let padding: CGFloat = 10

    var body: some View {

        NavigationView {

            #if os(iOS)

            self.view
                .navigationTitle("Network")
                .toolbar {

                    ToolbarItem(placement: .navigationBarLeading, content: {

                        Picker(selection: self.$timelineType, label: Text("Network visibility")) {
                            Text("Public").tag("public")
                            Text("Local").tag("local")
                        }
                            .pickerStyle(SegmentedPickerStyle())

                    })

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
                self.timeline.fetchPublicTimeline()
            }

    }

    var view: some View {

        List(self.timeline.statuses) { status in

            StatusView(status: status)
                .buttonStyle(PlainButtonStyle())

        }

    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
