//
//  CompactTimelineView.swift
//  iOS
//
//  Created by Alejandro Modroño Vara on 09/07/2020.
//

import SwiftUI

struct CompactTimelineView: View {

    var body: some View {
        NavigationView {

            List(0 ..< 5) { _ in

                StatusView()
                    .padding(.vertical)
                    .buttonStyle(PlainButtonStyle())

            }

            .navigationTitle("Timeline")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}, label: {
                        Image(systemName: "line.horizontal.3.decrease")
                            .imageScale(.large)
                    })
                }
            }

        }
    }
}

struct CompactTimelineView_Previews: PreviewProvider {
    static var previews: some View {
        CompactTimelineView()
    }
}
