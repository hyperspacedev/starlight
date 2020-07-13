//
//  ProfileView.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/13/20.
//

import SwiftUI

/// The view for displaying profiles.
struct ProfileView: View {

    @State var editable: Bool = false
    @State var account: Account?

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

                        Text("Point Flash")
                            .font(.title)
                            .bold()

                        Text("STARLIGHT DEV")
                            .foregroundColor(.secondary)
                            .padding(.all, 5)
                            .font(.caption2)
                            .background(
                                Color(.systemGray5)
                                    .cornerRadius(3)
                            )

                        Text("BOT")
                            .foregroundColor(.white)
                            .padding(.all, 5)
                            .font(.caption2)
                            .background(
                                Color.blue
                                    .cornerRadius(3)
                            )

                    }

                    Text("@iamnotabug")
                        .font(.callout)
                        .foregroundColor(.secondary)

                    Text("Photographer for @ScotiaNews.")
                        .padding(.top, 10)

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
                    .padding(.top, 40)

                List {
                    Text("Statuses for this profile go here.")
                }
                .listStyle(PlainListStyle())
            }
        }
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

                        Text("80")
                            .font(.system(size: 20))

                        Text("Followers")
                            .fontWeight(.semibold)

                    }

                    Spacer()

                    Divider()

                    Spacer()

                    VStack {

                        Text("20")
                            .font(.system(size: 20))

                        Text("Following")
                            .fontWeight(.semibold)

                    }

                    Spacer()

                    Divider()

                }

                Spacer()

                VStack {

                    Text("300")
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
