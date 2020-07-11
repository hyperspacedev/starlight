//
//  ThreadView.swift
//  Codename Starlight
//
//  Created by Alejandro Modroño Vara on 09/07/2020.
//

import SwiftUI

struct ThreadView: View {
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
                            Text("79 replies").font(.subheadline)
                        }
                    }
                }
            #else
            self.view
                .buttonStyle(PlainButtonStyle())
                .navigationTitle("Thread")
                .navigationSubtitle("79 replies")
            #endif

        }

    }

    var view: some View {

        List {

            StatusView(isPresented: true)

            ForEach(0..<3) { _ in

                StatusView()
                    .padding(.vertical, 5)

            }

        }

    }
}

struct ThreadView_Previews: PreviewProvider {
    static var previews: some View {
        ThreadView()
    }
}
