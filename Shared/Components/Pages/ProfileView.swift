//
//  ProfileView.swift
//  Starlight
//
//  Created by Marquis Kurt on 25/9/21.
//

import SwiftUI
import Chica
import StylableScrollView

struct ProfileView: View, InternalStateRepresentable {
    
    enum ProfileContext {
        case currentUser
        case user(id: String)
    }
    
    var context: ProfileContext

    @Environment(\.colorScheme) var scheme
    
    @State var state: ViewState = ViewState.initial
    @State private var account: Account?
    @State var isPage1: Bool = true
    @State var availableSize: CGSize = CGSize.init()
    @State var isFollowing: Bool = false
    @State var tabBarOffset: CGFloat = 0
    @State private var statusType: Int = 1
    
    var body: some View {
        StylableScrollView(.vertical) {
            VStack(spacing: 0) {

                VStack(spacing: 20) {
                    ZStack {
                        HStack {

                            VStack(alignment: .leading) {

                                Text("10.0")
                                    .font(.system(size: 17, weight: .semibold, design: .rounded))

                                Text("Rating")
                                    .font(.system(size: 18, weight: .regular, design: .rounded))
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            VStack(alignment: .leading) {

                                Text("1.64k")
                                    .font(.system(size: 17, weight: .semibold, design: .rounded))

                                Text("Posts")
                                    .font(.system(size: 18, weight: .regular, design: .rounded))
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            VStack(alignment: .leading) {

                                Text("108")
                                    .font(.system(size: 17, weight: .semibold, design: .rounded))

                                Text("Following")
                                    .font(.system(size: 18, weight: .regular, design: .rounded))
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            VStack(alignment: .leading) {

                                Text("6.4M")
                                    .font(.system(size: 17, weight: .semibold, design: .rounded))

                                Text("Followers")
                                    .font(.system(size: 18, weight: .regular, design: .rounded))
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            Button(action: { self.isPage1.toggle() }) {
                                Image(systemName: "chevron.right")
                                    .font(.headline)
                                    .foregroundColor(Color(.systemGray3))
                            }

                        }
                        .offset(x: self.isPage1 ? 0 : -self.availableSize.width)

                        HStack {

                            Button(action: {
                                self.isPage1.toggle()
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.headline)
                                    .foregroundColor(Color(.systemGray3))
                            }

                            Spacer()

                            VStack(alignment: .leading) {

                                Text("Sotogrande, Cádiz")
                                    .font(.system(size: 17, weight: .semibold, design: .rounded))

                                Text("Location")
                                    .font(.system(size: 18, weight: .regular, design: .rounded))
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            VStack(alignment: .leading) {

                                Text("16 April 2020")
                                    .font(.system(size: 17, weight: .semibold, design: .rounded))

                                Text("Joined")
                                    .font(.system(size: 18, weight: .regular, design: .rounded))
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                        }
                        .offset(x: self.isPage1 ? UIScreen.main.bounds.width : 0)
                        
                    }
                    .animation(.spring())

                    Divider()
                    
                }
                .padding([.horizontal, .top])
                .zIndex(0.9)

                HStack {
                    Text("\(self.account?.note.toMarkdown() ?? "")")
                        .multilineTextAlignment(.leading)
                        .padding()

                    Spacer()
                }

                Divider()

                if self.account != nil {
                    self.fields
                }

                Picker(selection: self.$statusType, label: Text("Tweet style")) {
                    Text("Posts").tag(1)
                    Text("Replies").tag(2)
                    Text("Likes").tag(3)
                    Text("Media").tag(4)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .background(Color.systemGray6(for: self.scheme))
                .offset(y: self.tabBarOffset < 100 ? -tabBarOffset + 100 : 0)
                .overlay {
                    GeometryReader { proxy -> Color in

                        let minY = proxy.frame(in: .global).minY

                        Task.init {
                            self.tabBarOffset = minY
                        }

                        return Color.clear
                    }
                }
                .zIndex(0.9)

                TimelineScrollViewCompatible(timeline: .home)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal)

            }
        }
        .onAppear {
            Task {
                loadData()
            }
        
        }
        .scrollViewStyle(
            StretchableScrollViewStyle(
                header: {
                    accountHeader
                },
                title: {
                    title
                },
                navBarContent: { Text(account?.getName().emojified() ?? "misc.placeholder")
                        .bold()

                    .navigationBarElement(
                        axis: .trailing,
                        {
                            self.followButton
                        }
                    )

                }
            )
        )
        .transformSize { size in
            Task {
                self.availableSize = size
            }
        }
    }

    private var fields: some View {

        let count = self.account!.fields.count

        return VStack {
            VStack(spacing: 0) {
                Divider()
                VStack {

                    ForEach(0 ..< count, content: { index in

                        HStack(spacing: 5) {

                            Text("\(self.account!.fields[index].name)")
                                .bold()

                            if (self.account!.fields[index].verifiedAt != nil) {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.green)
                                    .opacity(0.7)
                            }

                            Spacer()

                            Text("\(self.account!.fields[index].value.toMarkdown())")
                                .lineLimit(1)

                        }
                        .padding(.trailing,10)

                        // Element is not the last of the array
                        if index != count - 1 {
                            Divider()
                        }

                    })

                }
                .padding(.leading,10)
                .padding(.vertical,15)
                Divider()

            }
            .background(Color(.systemBackground))
            .padding(.top)

        }
        .frame(width: self.availableSize.width, height: CGFloat(count * 60))
        .background(Color.systemGray6(for: self.scheme))
    }

    private var followButton: some View {
        Group {
            if self.isFollowing {
                Button(action: {
                    self.isFollowing.toggle()
                }) {
                    Text("UNFOLLOW")
                        .font(.system(size: 14))
                        .bold()
                        .padding(5)
                        .padding(.horizontal, 5)
                        .background(
                            RoundedRectangle(cornerRadius: 35)
                                .foregroundColor(.white)
                        )
                        .foregroundColor(.blue)
                }
            } else {
                Button(action: {
                    self.isFollowing.toggle()
                }) {
                    Text("FOLLOW")
                        .font(.system(size: 14))
                        .bold()
                        .padding(5)
                        .padding(.horizontal, 5)
                        .background(
                            RoundedRectangle(cornerRadius: 35)
                                .foregroundColor(.blue)
                        )
                        .foregroundColor(.white)
                }
            }
        }
    }

    private var title: some View {
        HStack {
            ProfileImage(
                for: .currentUser,
                size: .medium
            )
                .shadow(color: .black, radius: 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.white, lineWidth: 2)
                )

            VStack(alignment: .leading, spacing: 0) {

                HStack {
                    Text(account?.getName().emojified() ?? "")
                        .bold()
                        .font(.title)
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 10)

                    if ((self.account?.isDev) != nil) {
                        Text("DEV")
                            .bold()
                            .foregroundColor(.white)
                            .padding(5)
                            .background(
                                Color.secondary
                                    .cornerRadius(5)
                        )
                    }
                }

                Text("@\(self.account?.acct ?? "")")
                    .foregroundColor(.white)
                    .opacity(0.7)
                    .shadow(color: .black, radius: 10)
            }

        }
    }

    private var accountHeader: some View {
        AsyncImage(url: URL(string: account?.headerStatic ?? "")) { phase in
            switch phase {
            case .success(let header):
                header
                Image("banner")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case .empty, .failure:
                Color.accentColor.redacted(reason: .placeholder)
            @unknown default:
                Color.accentColor.redacted(reason: .placeholder)
            }
        }
    }
    
    internal func loadData() {
        Task.init {
            state = .loading
            do {
                try await getAccountData()
                state = .loaded
            } catch {
                state = .errored(reason: "Unknown error")
            }
        }
    }
    
    private func getAccountData() async throws {
        switch context {
        case .currentUser:
            account = try await Chica.shared.request(.get, for: .verifyAccountCredentials)
        case .user(let id):
            account = try await Chica.shared.request(.get, for: .account(id: id))
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(context: .currentUser)
    }
}
