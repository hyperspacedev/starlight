//
//  TimelineView.swift
//  Codename Starlight
//
//  Created by Alejandro Modroño Vara on 10/07/2020.
//

import Foundation
import SwiftUI

#if canImport(SwiftUIRefresh)
import SwiftUIRefresh
#endif

struct NetworkView: View {

    @ObservedObject var timeline = NetworkViewModel()

    private let size: CGFloat = 300
    private let padding: CGFloat = 10
    private let displayPublic: Bool = true

    @State var isShowing: Bool = false
    @State var showTimelineFilterType: Bool = false

    var body: some View {

        NavigationView {

            #if os(iOS)

            self.view
                .listStyle(GroupedListStyle())
                .pullToRefresh(isShowing: $isShowing) {
                    self.timeline.refreshTimeline(from: self.timeline.statuses[0])
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.isShowing = false
                    }
                }
                .navigationTitle("Network")
                .navigationBarTitleDisplayMode(.automatic)
                .toolbar {

                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: { self.showTimelineFilterType.toggle() }, label: {
                            HStack {
                                Label(self.timeline.type == .public ? "Public" : "Community",
                                      systemImage: self.timeline.type == .public ? "globe": "person.2")
                                Spacer()
                            }
                        })
                    }

                    ToolbarItem(placement: .primaryAction) {

                        Button(action: {}, label: {
                            Image(systemName: "line.horizontal.3.decrease")
                                .imageScale(.large)
                        })

                    }
                }
                .actionSheet(isPresented: $showTimelineFilterType) {
                    ActionSheet(title: Text("Network Scope"),
                                buttons: [
                                    .default(Text("My community"), action: {
                                        timeline.type = TimelineScope.local
                                    }),
                                    .default(Text("Public timeline"), action: {
                                        timeline.type = TimelineScope.public
                                    }),
                                    .cancel(Text("Dismiss"), action: {})
                                ])
                    }

            #else

            self.view
                .navigationTitle("Network")
                .navigationSubtitle("\(Date())")

            #endif

        }

    }

    var view: some View {
        List {

            Section {

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

                    StatusList(self.timeline.statuses, action: { currentStatus in
                        self.timeline.updateTimeline(currentItem: currentStatus)
                    })

                }
            }

            }
            .animation(.spring())
            .onAppear {
                self.timeline.fetchTimeline()
            }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
