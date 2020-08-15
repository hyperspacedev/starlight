//
//  TimelineView.swift
//  Codename Starlight
//
//  Created by Alejandro Modroño Vara on 10/07/2020.
//

import Foundation
import SwiftUI

#if canImport(SwiftUIRefresh) && canImport(SwipeCell)
import SwiftUIRefresh
import SwipeCell
#endif

struct NetworkView: View {

    @ObservedObject var timeline = NetworkViewModel()

    private let size: CGFloat = 300
    private let padding: CGFloat = 10
    private let displayPublic: Bool = true

    @State var isShowing: Bool = false

    var body: some View {

        NavigationView {

            #if os(iOS)

            StatusList(
                self.timeline.statuses,
                context: .list,
                action: { currentStatus in
                    self.timeline.updateTimeline(currentItem: currentStatus)
                }
            )
                .onAppear {
                    self.timeline.fetchTimeline()
                }
                .animation(.spring())
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

                        // swiftlint:disable no_space_in_method_call multiple_closures_with_trailing_closure
                        Menu {
                            Button("My community", action: {
                                withAnimation(.spring()) {
                                    timeline.type = TimelineScope.local
                                }
                            })
                            Button("Public timeline", action: {
                                withAnimation(.spring()) {
                                    timeline.type = TimelineScope.public
                                }
                            })
                        } label: {
                            Label(self.timeline.type == .public ? "Public" : "Community",
                                  systemImage: self.timeline.type == .public ? "globe": "person.2")
                        }
                        // swiftlint:enable no_space_in_method_call multiple_closures_with_trailing_closure

                    }

                    ToolbarItem(placement: .primaryAction) {

                        Button(action: {}, label: {
                            Image(systemName: "line.horizontal.3.decrease")
                                .imageScale(.large)
                        })

                    }
                }

            #else

            StatusList(self.timeline.statuses,
                       context: .list,
                       action: { currentStatus in
                        self.timeline.updateTimeline(currentItem: currentStatus)
                       })
                .onAppear {
                    self.timeline.fetchTimeline()
                }
                .animation(.spring())
                .navigationTitle("Network")
                .navigationSubtitle("\(Date())")

            #endif

        }

    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
