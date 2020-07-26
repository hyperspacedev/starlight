//
//  ProfileView.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/13/20.
//

import SwiftUI
import Atributika

struct ProfileView: View {

    @ObservedObject var accountInfo: ProfileViewModel = ProfileViewModel(accountID: "1")

    #if os(iOS)
    @State var isShowing: Bool = false
    @State var searchText: String = ""
    @State var isParent: Bool = true
    #endif

    var body: some View {
        #if os(iOS)
        if self.isParent {
            NavigationView {
                self.view
                    .navigationBarSearch(self.$searchText, placeholder: "Search for content in this profile...")
                    .pullToRefresh(isShowing: $isShowing) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.isShowing = false
                        }
                    }
            }
        } else {
            self.view
                .navigationBarSearch(self.$searchText, placeholder: "Search for content in this profile...")
                .pullToRefresh(isShowing: $isShowing) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.isShowing = false
                    }
                }
        }

        #else
        self.view
        #endif
    }

    var view: some View {
        ScrollView {

            ProfileViewBanner(
                header: self.accountInfo.data?.headerStatic,
                avatar: self.accountInfo.data?.avatarStatic
            )

//            Image("sotogrande")
//                .asBanner()
//

            ProfileViewHeader(accountInfo: self.accountInfo)

            StatusList(self.accountInfo.statuses, context: .noneWithSeparator, action: {_ in})
                .padding(.horizontal)

        }
            .onAppear {
                self.accountInfo.fetchProfile()
                self.accountInfo.fetchProfileStatuses()
            }
            .padding(.horizontal)
            .navigationTitle(self.accountInfo.data?.displayName ?? "Profile")
            .navigationBarTitleDisplayMode(.inline)
    }

}

struct ProfileViewBanner: View {

    @State var header: String?
    @State var avatar: String?

    var body: some View {
        RemoteImage(
            from: self.header,
            placeholder: {
                Image("sotogrande")
                    .asBanner()
//                    .overlay(
//                        self.avatarImage.offset(y: 64),
//                        alignment: .bottomLeading
//                    )
                    .redacted(reason: .placeholder)
            },
            result: { image in
                image
                    .asBanner()
//                    .overlay(
//                        self.avatarImage.offset(y: 64),
//                        alignment: .bottomLeading
//                    )
            }
        )
    }

    var avatarImage: some View {
        RemoteImage(
            from: self.avatar,
            placeholder: {
                Image("sotogrande")
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .redacted(reason: .placeholder)
            },
            result: { image in
                image
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .redacted(reason: .placeholder)
            }
        )
            .frame(width: 100, height: 100)
            .padding()
            .background(
                Circle()
                    .frame(width: 110, height: 110)
                    .foregroundColor(backgroundColor)
            )
    }

}

struct ProfileViewHeader: View {

    @ObservedObject var accountInfo: ProfileViewModel

    @State var infoShown: [ProfileViewInfo] = []

    // MARK: USER NOTE TEXT STYLES
    private let rootStyle: Style = Style("p")
        .font(.systemFont(ofSize: 17, weight: .regular))
    private let linkStyle: Style = Style("a")
        .foregroundColor(#colorLiteral(red: 0.6050000191, green: 0.3829999864, blue: 1, alpha: 1))

    /// Configure the label to match the styling for the status.
    private func configureLabel(_ label: AttributedLabel, size: CGFloat = 17) {
        label.numberOfLines = 0
        label.textColor = .label
        label.lineBreakMode = .byWordWrapping
        label.onClick = { labelClosure, detection in
            switch detection.type {
            case .link(let url):
                openUrl(url)
            default:
                break
            }
        }
    }

    var bounds: CGFloat {
        #if os(macOS)
        // Note: Need to subtract sidebar size here.
        let bounds: CGFloat = NSApplication.shared.mainWindow?.frame.width ?? 0
        #else
        let bounds: CGFloat = UIScreen.main.bounds.width
        #endif

        return bounds
    }

    var padding: CGFloat = 84

    var body: some View {
        VStack {
            if self.accountInfo.data != nil {
                header
            } else {
                placeholder
                    .redacted(reason: .placeholder)
            }
        }
    }

    var header: some View {
        VStack(alignment: .leading) {

            HStack {

                Text((accountInfo.data?.displayName)!)
                    .font(.title)
                    .bold()

                if let badge = accountInfo.badge {
                    Text(badge.label)
                            .fontWeight(.semibold)
                            .foregroundColor(badge.labelColor)
                            .padding(.all, 5)
                            .font(.caption2)
                            .background(
                                RoundedRectangle(cornerRadius: 3.0)
                                    .foregroundColor(badge.backgroundColor)
                                    .cornerRadius(3)
                            )
                }

                if let isBot = accountInfo.data?.bot {

                    if isBot {
                        Text("BOT")
                            .bold()
                            .foregroundColor(.white)
                            .padding(.all, 5)
                            .font(.caption2)
                            .background(
                                Color.blue
                                    .cornerRadius(3)
                            )
                    }

                }

                Spacer()

                // swiftlint:disable:next no_space_in_method_call
                Menu {
                    if let data = accountInfo.data {
                        Text("Date created: \(data.createdAt.getDate()!)")
                    }
                    Divider()
                    Button(action: {}, label: {Text("Share \(Image(systemName: "square.and.arrow.up"))")})
                    Button(action: {}, label: {Text("Show more info")})
                    Menu("Show more info") {
                        Button(action: {
                            if self.infoShown.contains(.dateCreated) {
                                self.infoShown = infoShown.filter { $0 != .dateCreated }
                            } else {
                                self.infoShown.append(.dateCreated)
                            }
                        }, label: {
                            if infoShown.contains(.dateCreated) {
                                Image(systemName: "checkmark")
                            }
                            Text("Date created")
                        })
                        Button(action: {
                            if self.infoShown.contains(.location) {
                                self.infoShown = infoShown.filter { $0 != .location }
                            } else {
                                print("added location")
                                self.infoShown.append(.location)
                            }
                        }, label: {
                            if infoShown.contains(.location) {
                                Image(systemName: "checkmark")
                            }
                            Text("Location")
                        })
                        Button(action: {
                            if self.infoShown.contains(.fields) {
                                self.infoShown = infoShown.filter { $0 != .fields }
                            } else {
                                self.infoShown.append(.fields)
                            }
                        }, label: {
                            if infoShown.contains(.fields) {
                                Image(systemName: "checkmark")
                            }
                            Text("Fields")
                        })
                    }
                    Button(action: {}, label: {Text("Block @\((accountInfo.data?.acct)!)")})
                    Button(action: {}, label: {Text("Report @\((accountInfo.data?.acct)!)")})
                        .foregroundColor(.red)
                    Button("Dismiss", action: {})
                } label: {
                    Image(systemName: "ellipsis")
                        .imageScale(.large)
                }

            }

            Text("@\((accountInfo.data?.acct)!)")
                .font(.callout)
                .foregroundColor(.secondary)

            VStack(alignment: .leading) {
                AttributedTextView(
                    attributedText: "\((accountInfo.data?.note)!)"
                        .style(tags: rootStyle),
                    configured: { label in
                        self.configureLabel(label, size: 20)
                    },
                    maxWidth: bounds - padding)
                .fixedSize()
            }

            Divider()

            self.stats

            Divider()

        }
            .padding(.horizontal)
            .padding(.top, 40)
    }

    var placeholder: some View {
        VStack(alignment: .leading) {

            HStack {

                Text("User")
                    .font(.title)
                    .bold()

                Text("Badge")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.all, 5)
                        .font(.caption2)
                        .background(
                            RoundedRectangle(cornerRadius: 3.0)
                                .foregroundColor(.red)
                                .cornerRadius(3)
                        )

                Text("BOT")
                    .bold()
                    .foregroundColor(.white)
                    .padding(.all, 5)
                    .font(.caption2)
                    .background(
                        Color.blue
                            .cornerRadius(3)
                    )

                Spacer()

                // swiftlint:disable:next no_space_in_method_call
                Menu {
                    Text("Date crated: 00/00/0000")
                        .redacted(reason: .placeholder)
                    Divider()
                    Button(action: {}, label: {Text("Share \(Image(systemName: "square.and.arrow.up"))")})
                    Button(action: {}, label: {Text("Show more info")})
                    Menu("Show more info") {
                        Button(action: {
                            if self.infoShown.contains(.dateCreated) {
                                self.infoShown = infoShown.filter { $0 != .dateCreated }
                            } else {
                                self.infoShown.append(.dateCreated)
                            }
                        }, label: {
                            if infoShown.contains(.dateCreated) {
                                Image(systemName: "checkmark")
                            }
                            Text("Date created")
                        })
                        Button(action: {
                            if self.infoShown.contains(.location) {
                                self.infoShown = infoShown.filter { $0 != .location }
                            } else {
                                print("added location")
                                self.infoShown.append(.location)
                            }
                        }, label: {
                            if infoShown.contains(.location) {
                                Image(systemName: "checkmark")
                            }
                            Text("Location")
                        })
                        Button(action: {
                            if self.infoShown.contains(.fields) {
                                self.infoShown = infoShown.filter { $0 != .fields }
                            } else {
                                self.infoShown.append(.fields)
                            }
                        }, label: {
                            if infoShown.contains(.fields) {
                                Image(systemName: "checkmark")
                            }
                            Text("Fields")
                        })
                    }
                    Button(action: {}, label: {Text("Block @\(accountInfo.data?.acct ?? "user")")})
                    Button(action: {}, label: {Text("Report @\(accountInfo.data?.acct ?? "user")")})
                        .foregroundColor(.red)
                    Button("Dismiss", action: {})
                } label: {
                    Image(systemName: "ellipsis")
                        .imageScale(.large)
                }

            }

            Text("@\(accountInfo.data?.acct ?? "user")")
                .font(.callout)
                .foregroundColor(.secondary)

            Text("This is an example bioghraphy that will be displayed as a placeholder until the actual biography is fetched.")

            Divider()

            self.statsPlaceholder

            Divider()

        }
            .padding(.horizontal)
            .padding(.top, 40)
    }

    var stats: some View {
        HStack {

            VStack {

                Text("\((accountInfo.data?.followersCount.roundedWithAbbreviations)!)")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))

                Text("Followers \(Image(systemName: "person.3"))")
                    .fontWeight(.semibold)
            }

            Spacer()

            VStack {

                Text("\((accountInfo.data?.followingCount.roundedWithAbbreviations)!)")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))

                Text("Following  \(Image(systemName: "person.2"))")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .fontWeight(.semibold)

            }

            Spacer()

            VStack {

                Text("\((accountInfo.data?.statusesCount.roundedWithAbbreviations)!)")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))

                Text("Toots \(Image(systemName: "doc.richtext"))")
                    .fontWeight(.semibold)

            }

        }
    }
    
    var statsPlaceholder: some View {
        HStack {

            VStack {

                Text("\(1000000.roundedWithAbbreviations)")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))

                Text("Followers \(Image(systemName: "person.3"))")
                    .fontWeight(.semibold)
            }

            Spacer()

            VStack {

                Text("\(1000000.roundedWithAbbreviations)")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))

                Text("Following  \(Image(systemName: "person.2"))")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .fontWeight(.semibold)

            }

            Spacer()

            VStack {

                Text("\(1000000.roundedWithAbbreviations)")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))

                Text("Toots \(Image(systemName: "doc.richtext"))")
                    .fontWeight(.semibold)

            }

        }
    }
}

extension Image {
    func asBanner() -> some View {
        resizable()
            .scaledToFit()
            .frame(width: UIScreen.main.bounds.width)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
