//
//  ProfileView.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/13/20.
//

import SwiftUI

/// The view for displaying profiles.
struct ProfileView: View {

    @ObservedObject var accountInfo: ProfileViewModel = ProfileViewModel(accountID: "1")

    @State var editable: Bool = false

    let devs = [
        "alicerunsonfedora@mastodon.social",
        "amodrono@mastodon.social"
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {

                Image("sotogrande")
                    .resizable()
//                    .scaledToFit()
                    .overlay(
                        Image("pointFlash")
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 100, height: 100)
                            .padding()
                            .background(
                                Circle()
                                    .frame(width: 110, height: 110)
                                    .foregroundColor(.white)
                            )
                            .offset(y: 64),
                        alignment: .bottomLeading
                    )

                VStack(alignment: .leading) {

                    HStack {

                        Text(accountInfo.data?.displayName ?? "E")
                            .font(.title)
                            .bold()

                        if let username = accountInfo.data?.displayName {

                            if devs.contains(username) {
                                Text("STARLIGHT DEV")
                                    .foregroundColor(.secondary)
                                    .padding(.all, 5)
                                    .font(.caption2)
                                    .background(
                                        Color(.systemGray5)
                                            .cornerRadius(3)
                                    )
                            }

                        }

                        if let isBot = accountInfo.data?.bot {

                            if isBot {
                                Text("BOT")
                                    .foregroundColor(.white)
                                    .padding(.all, 5)
                                    .font(.caption2)
                                    .background(
                                        Color.blue
                                            .cornerRadius(3)
                                    )
                            }

                        }

                    }

                    Text("@iamnotabug")
                        .font(.callout)
                        .foregroundColor(.secondary)

                    Text("Photographer for @ScotiaNews.")
                        .padding(.top, 10)
                }
                    .padding(.horizontal)
                    .padding(.top, 40)

                self.stats

                VStack(alignment: .leading) {
                    HStack(spacing: 16.0) {
                        if editable {
                            Button(action: {}, label: {
                                Label("Edit", systemImage: "square.and.pencil")
                            })
                        } else {
                            Button(action: {}, label: {
                                Label("Follow", systemImage: "person.badge.plus")
                            })
                        }
                        Button(action: {}, label: {
                            Label("Mention", systemImage: "bubble.left")
                        })
                        Spacer()
                        Button(action: {}, label: {
                            Image(systemName: "ellipsis.circle")
                        })
                        .contextMenu {

                            Button(action: {}, label: {
                                Label("Share", systemImage: "square.and.arrow.up")
                            })

                            Button(action: {}, label: {
                                Label("Show more info", systemImage: "tablecells")
                            })

                            if !editable {
                                Button(action: {}, label: {
                                    Label("Block @iamnotabug", systemImage: "person.crop.circle.fill.badge.xmark")
                                })
                                Button(action: {}, label: {
                                    Label("Report @iamnotabug", systemImage: "hand.raised.fill")
                                })
                            }
                        }
                    }
                }
                    .padding(.horizontal)

                List {
                    Text("Statuses for this profile go here.")
                }
                .listStyle(PlainListStyle())
            }
        }
            .edgesIgnoringSafeArea(.top)
            .onAppear {
                self.accountInfo.fetchProfile()
            }
    }

    var stats: some View {
        HStack {

            Group {

                Spacer()

                VStack {

                    Text("\(3142.roundedWithAbbreviations)")
                        .font(.system(size: 20))

                    Text("Followers")
                        .fontWeight(.semibold)

                }

                Spacer()

            }

            Rectangle()
                .foregroundColor(.white)
                .frame(width: 1, height: 60)

            Group {

                Spacer()

                VStack {

                    Text("\(200.roundedWithAbbreviations)")
                        .font(.system(size: 20))

                    Text("Following")
                        .fontWeight(.semibold)

                }

                Spacer()

            }

            Rectangle()
                .foregroundColor(.white)
                .frame(width: 1, height: 60)

            Group {

                Spacer()

                VStack {

                    Text("\(19360.roundedWithAbbreviations)")
                        .font(.system(size: 20))

                    Text("Toots")
                        .fontWeight(.semibold)

                }

                Spacer()

            }

        }
            .background(
                Color.blue
                    .opacity(0.2)
            )

    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
