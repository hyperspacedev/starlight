//
//  ThreadView.swift
//  Codename Starlight
//
//  Created by Alejandro Modroño Vara on 09/07/2020.
//

import SwiftUI

#if canImport(SwiftlySearch)
import SwiftlySearch
#endif

struct ThreadView: View {

    @StateObject var threadModel = ThreadViewModel()
    public let mainStatus: Status

    #if os(iOS)
    @State var searchText: String = ""
    #endif

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
                .navigationBarSearch(self.$searchText, placeholder: "Search in thread...")
            #else
            self.view
                .buttonStyle(PlainButtonStyle())
                .navigationTitle("Thread")
                .navigationSubtitle("\(self.mainStatus.repliesCount) replies")
            #endif

        }

    }

    var view: some View {

        ScrollViewReader { scrollview in
            List {

                if let context = self.threadModel.context {

                    ForEach(context.ancestors) { currentStatus in

                        StatusView(status: currentStatus)
                            .padding(.vertical, 5)

                    }
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                scrollview.scrollTo(self.mainStatus)
                            })
                        }

                }

                StatusView(isMain: true, status: mainStatus)

                if let context = self.threadModel.context {

//                    StatusList(context.descendants,
//                               condition: { _ in
//                                    if currentStatus.inReplyToID == self.mainStatus.id {
//                                        StatusView(status: currentStatus)
//                                            .padding(.vertical, 5)
//                                    }
//                               }
//                    )

                    ForEach(context.descendants) { currentStatus in

                        if currentStatus.inReplyToID == self.mainStatus.id {
                            StatusView(status: currentStatus)
                                .padding(.vertical, 5)
                        }

                    }

                } else {

                    HStack {

                        Spacer()

                        VStack {
                            Spacer()
                            ProgressView(value: 0.5)
                                .progressViewStyle(CircularProgressViewStyle())
                            Text("Loading replies...")
                            Spacer()
                        }

                        Spacer()

                    }
                }

            }
        }
            .onAppear {
                self.threadModel.fetchContext(for: self.mainStatus.id)
            }

    }
}

struct ThreadView_Previews: PreviewProvider {

    @ObservedObject static var timeline = NetworkViewModel()

    static var previews: some View {
        ThreadView(mainStatus: self.timeline.statuses[0])
    }
}
