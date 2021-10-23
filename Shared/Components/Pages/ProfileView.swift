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
                    blurbHeader
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

                if self.account != nil { self.fields }

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
                        Task.init { self.tabBarOffset = minY }
                        return Color.clear
                    }
                }
                .zIndex(0.9)

                if let acct = account {
                    TimelineScrollViewCompatible(scope: .profile(id: acct.id))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.horizontal)
                } else {
                    StackedLabel(image: Image(systemName: "star"), title: "misc.placeholder") {
                        Button(action: { loadData() }) {
                            Text("actions.reload")
                        }
                    }
                }


            }
        }
        .onAppear { loadData() }
        .scrollViewStyle(
            StretchableScrollViewStyle(
                header: { accountHeader },
                title: { title },
                navBarContent: {
                    Text(account?.getName().emojified() ?? "tabs.profile")
                        .bold()
                        .navigationBarElement(axis: .trailing, { navbarGroup })
                }
            )
        )
        .transformSize { size in
            Task {
                self.availableSize = size
            }
        }
    }
    
    // MARK: - Children Views
    
    /// The navbar header for an account, which contains a profile image and some other text.
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
    
    /// A blurb view displayed below the profile header.
    /// - Parameter data: The data that this blurb represents
    /// - Parameter title: The title for the data
    private func blurb(_ data: String, with title: String) -> some View {
        VStack(alignment: .leading) {
            Text(data)
                .font(.system(size: 17, weight: .semibold, design: .rounded))
            Text(title)
                .font(.system(size: 18, weight: .regular, design: .rounded))
                .foregroundColor(.gray)
        }
    }
    
    /// Returns a button that toggles the state of the blurbs.
    private func blurbButton(backward: Bool = false) -> some View {
        // FIXME: This action doesn't seem to actually trigger anything, as if the button is dead.
        // NOTE: Also, maybe we should make this a scrollable list horizontally?
        Button(action: { self.isPage1.toggle() }) {
            Image(systemName: backward ? "chevron.left" : "chevron.right")
                .font(.headline)
                .foregroundColor(Color(.systemGray3))
        }
    }
    
    /// A view that contains glance-able information about a profile sich as number of posts, follows, location, etc.
    private var blurbHeader: some View {
        ZStack {
            HStack {
                // NOTE: I'm not sure what "Rating" here refers to, since there's nothing
                // in the API that references this.
                // blurb("10.0", with: "Rating")
                // Spacer()
                blurb("\(account?.statusesCount ?? 0)", with: "Posts")
                Spacer()
                blurb("\(account?.followersCount ?? 0)", with: "Following")
                Spacer()
                blurb("\(account?.followingCount ?? 0)", with: "Followers")
                Spacer()
                if let acct = account {
                    blurb(
                        RelativeDateTimeFormatter()
                            .localizedString(for: acct.createdAt.toMastodonDate() ?? .now, relativeTo: .now)
                        , with: "Joined")
                    Spacer()
                }
                blurbButton()
            }
            .offset(x: self.isPage1 ? 0 : -self.availableSize.width)
            HStack {
                blurbButton(backward: true)
                Spacer()
                blurb("Sotogrande, Cádiz", with: "Location")
                Spacer()
            }
            .offset(x: self.isPage1 ? UIScreen.main.bounds.width : 0)
        }
        .animation(.spring(), value: isPage1)
    }

    /// A list of fields that pertain to the account.
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
                            Text("\(self.account!.fields[index].value.toEmojifiedMarkdown())")
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

    /// A button that toggles following/unfollowing users.
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
    
    /// A group that contains either a disabled follow button or an enabled follow button.
    var navbarGroup: some View {
        Group {
            switch context {
            case .currentUser:
                self.followButton
                    .disabled(true)
                    .opacity(0.5)
            case .user(_):
                self.followButton
            }
        }
    }
    
    /// Returns a profile badge that denotes the profile as special.
    /// - Parameter badgeText: A localized string key that describes the badge.
    func profileBadge(_ badgeText: LocalizedStringKey) -> some View {
        Text(badgeText)
            .bold()
            .foregroundColor(.white)
            .padding(5)
            .background(
                Color.secondary
                    .cornerRadius(5)
        )
    }

    /// The title for this view.
    private var title: some View {
        HStack {
            ProfileImage(
                for: getProfileImageContext(),
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

                    if (self.account?.isDev == true) { profileBadge("DEV") }
                    if (account?.bot == true) { profileBadge("BOT") }
                }

                Text("@\(self.account?.acct ?? "")")
                    .foregroundColor(.white)
                    .opacity(0.7)
                    .shadow(color: .black, radius: 10)
            }

        }
    }
    
    // MARK: - View Methods
    /// Sets the account to the specified account context.
    private func getAccountData() async throws {
        switch context {
        case .currentUser:
            account = try await Chica.shared.request(.get, for: .verifyAccountCredentials)
        case .user(let id):
            account = try await Chica.shared.request(.get, for: .account(id: id))
        }
    }
    
    /// Loads the data into the view.
    internal func loadData() {
        Task.init {
            if account != nil { return }
            state = .loading
            do {
                try await getAccountData()
                state = .loaded
            } catch {
                state = .errored(reason: "Unknown error")
            }
        }
    }

    private func getProfileImageContext() -> ProfileImage.AccountType {
        switch context {
        case .currentUser:
            return ProfileImage.AccountType.currentUser
        case .user(let id):
            return ProfileImage.AccountType.user(id: id)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(context: .currentUser)
    }
}
