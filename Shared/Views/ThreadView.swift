//
//  ThreadView.swift
//  Codename Starlight
//
//  Created by Alejandro Modroño Vara on 09/07/2020.
//

import SwiftUI

struct ThreadView: View {

    public let mainStatus: Status

    var body: some View {

        VStack {

            #if os(iOS)
            self.view
                .listStyle(GroupedListStyle())
                .onAppear {
                    UITableView.appearance().tableHeaderView = UIView(
                        frame: CGRect(
                            x: 0,
                            y: 0,
                            width: 0,
                            height: Double.leastNonzeroMagnitude)
                    )
                }
                .buttonStyle(PlainButtonStyle())
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        VStack {
                            Text("Thread").font(.headline)
                            Text("\(self.mainStatus.repliesCount) replies").font(.subheadline)
                        }
                    }
                }
            #else
            self.view
                .buttonStyle(PlainButtonStyle())
                .navigationTitle("Thread")
                .navigationSubtitle("\(self.mainStatus.repliesCount) replies")
            #endif

        }

    }

    var view: some View {

        List {

            StatusView(isPresented: true, status: mainStatus)

            ForEach( 0 ..< 5) { _ in

                StatusView(status: self.mainStatus)
                    .padding(.vertical, 5)

            }

        }

    }
}

struct ThreadView_Previews: PreviewProvider {

    @ObservedObject static var timeline = TimelineViewModel()

    static var previews: some View {
        ThreadView(mainStatus: self.timeline.statuses[0])
    }
}
