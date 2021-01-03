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

    @StateObject var viewModel = ContextViewModel()
    public let mainStatus: Status

    #if os(iOS)
    @State var searchText: String = ""
    @State var isShowing: Bool = false
    #endif

    var body: some View {

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
            .pullToRefresh(isShowing: $isShowing) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.isShowing = false
                }
            }
        #else
        self.view
            .buttonStyle(PlainButtonStyle())
            .navigationTitle("Thread")
            .navigationSubtitle("\(self.mainStatus.repliesCount) replies")
        #endif

    }

    var view: some View {

        List {
            if let context = self.viewModel.context {

                if !context.ancestors.isEmpty {
                    StatusList(context.ancestors, placeholderCount: context.ancestors.count)
                        .animation(.spring())
                }

            }

            StatusView.view(
                StatusConfiguration.DisplayMode.presented,
                status: mainStatus
            )
                .buttonStyle(
                    PlainButtonStyle()
                )

            if let context = self.viewModel.context {

                if !context.descendants.isEmpty {
                    StatusList(context.descendants,
                               condition: { currentStatus in
                                    if currentStatus.inReplyToID == self.mainStatus.id {
                                        return true
                                    }
                                    return false
                               },
                               placeholderCount: context.descendants.count
                    )
                }

//                ForEach(context.descendants) { currentStatus in
//
//                    if currentStatus.inReplyToID == self.mainStatus.id {
//                        StatusView(status: currentStatus)
//                            .padding(.vertical, 5)
//                    }
//
//                }
            }
        }
            .animation(.spring())
            .onAppear(perform: {

                //  We fetch the context
                self.viewModel.fetch(for: self.mainStatus.id)
            })

    }
}

struct ThreadView_Previews: PreviewProvider {

    @ObservedObject static var timeline = TimelineViewModel()

    static var previews: some View {
        ThreadView(mainStatus: self.timeline.statuses[0])
    }
}
