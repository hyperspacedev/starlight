//
//  ThreadView.swift
//  iOS
//
//  Created by Alejandro Modroño Vara on 09/07/2020.
//

import SwiftUI

struct ThreadView: View {
    var body: some View {

        List {

            StatusView(isPresented: true)
//                .padding([.horizontal, .top])

            ForEach(0..<3) { _ in

                StatusView()
                    .padding(.vertical, 5)

//                Divider()
//                    .padding(.leading)

            }

        }
            .buttonStyle(PlainButtonStyle())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { // <2>
                ToolbarItem(placement: .principal) { // <3>
                    VStack {
                        Text("Thread").font(.headline)
                        Text("79 replies").font(.subheadline)
                    }
                }
            }

    }
}

struct ThreadView_Previews: PreviewProvider {
    static var previews: some View {
        ThreadView()
    }
}
