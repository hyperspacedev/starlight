//
//  StatusView.swift
//  iOS
//
//  Created by Alejandro Modroño Vara on 09/07/2020.
//

import SwiftUI

struct StatusView: View {

//    @State var status: Status = Status(id: "001", )
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {

        VStack(alignment: .leading) {

            HStack(alignment: .top) {

                Image("amodrono")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 50)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 5) {

                    HStack {

                        HStack(spacing: 5) {

                            Text("Hello, World!")
                                .font(.headline)

                            Text("@amodrono@mastodon.social")
                                .foregroundColor(.gray)
                                .lineLimit(1)

                        }

                        Spacer()

                        Text("· 24s")

                    }

                    VStack {

                        Text("This view shows how Mastodon statuses will look on cells. It also has some random text so that I can see how big content looks.")

                    }

                    self.actionButtons
                        .padding(.top)

                }

            }

        }

    }

    var actionButtons: some View {
        HStack {

            HStack {

                Image(systemName: "text.bubble")

                Text("20k")

            }

            Spacer()

            Button(action: {

            }, label: {

                HStack {

                    Image(systemName: "arrow.2.squarepath")

                    Text("10")

                }

            })
                .foregroundColor(
                    labelColor()
                )

            Spacer()

            Button(action: {

            }, label: {

                HStack {

                    Image(systemName: "heart")

                    Text("34k")
                }

            })
                .foregroundColor(
                    labelColor()
                )

        }

    }

}

struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
        StatusView()
    }
}
