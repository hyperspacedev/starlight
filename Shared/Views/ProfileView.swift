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

    @State var hideNavBar: Bool = true

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                self.header
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
            }
                .listStyle(PlainListStyle())
                .frame(maxHeight: .infinity)
            }
        }
        .navigationTitle("")
        .navigationBarHidden(hideNavBar)
        .onAppear {
            self.accountInfo.fetchProfile()
            self.accountInfo.fetchProfileStatuses()
        }
    }

    var header: some View {
        VStack(alignment: .leading) {
            Image("sotogrande")
                .resizable()
                        .scaledToFit()
                .overlay(
                    ProfileImage(
                        from: accountInfo.data?.avatarStatic,
                        placeholder: {
                            Circle()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                        },
                        size: 100)
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

                    Text(accountInfo.data?.displayName ?? "User")
                        .font(.title)
                        .bold()

    //                        Text("STARLIGHT DEV")
    //                            .foregroundColor(.secondary)
    //                            .padding(.all, 5)
    //                            .font(.caption2)
    //                            .background(
    //                                Color(.systemGray5)
    //                                    .cornerRadius(3)
    //                            )
    //
    //                        Text("BOT")
    //                            .foregroundColor(.white)
    //                            .padding(.all, 5)
    //                            .font(.caption2)
    //                            .background(
    //                                Color.blue
    //                                    .cornerRadius(3)
    //                            )

                }

                Text("@\(accountInfo.data?.acct ?? "user")")
                    .font(.callout)
                    .foregroundColor(.secondary)

                Text("\(accountInfo.data?.note ?? "No bio provided.")")
                    .padding(.top, 10)
                    .fixedSize(horizontal: false, vertical: true)
                self.stats
                    .padding(.top)

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
                .padding(.horizontal)
            }
                .padding(.horizontal, 10)
                .padding(.top, 40)
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
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
                    Text("Posts")
                        .fontWeight(.semibold)
                }
                Spacer()
                Divider()
            }
            .frame(height: 50)
                .padding(.top, -10)
            Divider()
                .padding(.top, -10)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
