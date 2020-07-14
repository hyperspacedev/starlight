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
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Image("sotogrande")
                        .resizable()
                        .overlay(
                            ProfileImage(from: accountInfo.data?.avatarStatic,
                                         placeholder: {
                                            Circle()
                                                .scaledToFit()
                                                .frame(width: 100, height: 100)
                                                .foregroundColor(.gray)
                                         },
                                         size: 100)
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

                            Text(accountInfo.data?.displayName ?? "User")
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

                        Text("@\(accountInfo.data?.acct ?? "user")")
                            .font(.callout)
                            .foregroundColor(.secondary)

                        Text("\(accountInfo.data?.note ?? "No bio provided.")")
                            .padding(.top, 10)
                            .fixedSize(horizontal: false, vertical: true)
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
                                        Label("Block @\(accountInfo.data?.acct ?? "user")", systemImage: "person.crop.circle.fill.badge.xmark")
                                    })
                                    Button(action: {}, label: {
                                        Label("Report @\(accountInfo.data?.acct ?? "user")", systemImage: "hand.raised.fill")
                                    })
                                }
                            }
                        }
                    }
                        .padding(.horizontal)

                    List {
                    Section {
                        if self.accountInfo.statuses.isEmpty {
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
                            ForEach(self.accountInfo.statuses, id: \.self.id) { status in
                                StatusView(status: status)
                                    .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
                .edgesIgnoringSafeArea(.top)
                .onAppear {
                    self.accountInfo.fetchProfile()
                    self.accountInfo.fetchProfileStatuses()
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarTitle("")
        .edgesIgnoringSafeArea(.top)
        
    }

    var stats: some View {
        VStack {
            Divider()
            HStack {
                Group {
                    Divider()
                    Spacer()
                    VStack {
                        Text("\(accountInfo.data?.followersCount ?? 0)")
                            .font(.system(size: 20))
                        Text("Followers")
                            .fontWeight(.semibold)
                    }
                    Spacer()
                    Divider()
                    Spacer()
                    VStack {
                        Text("\(accountInfo.data?.followingCount ?? 0)")
                            .font(.system(size: 20))
                        Text("Following")
                            .fontWeight(.semibold)
                    }
                    Spacer()
                    Divider()
                }
                Spacer()

                VStack {
                    Text("\(accountInfo.data?.statusesCount ?? 0)")
                        .font(.system(size: 20))

                    Text("Toots")
                        .fontWeight(.semibold)

                }

                Spacer()

            }
            .frame(height: 50)
                .padding(.top, -10)
            Divider()
                .padding(.top, -10)
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
