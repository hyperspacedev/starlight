//
//  ProfileView.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/13/20.
//

import SwiftUI
import Atributika
import URLImage

struct ProfileView: View {

    @ObservedObject var accountInfo: ProfileViewModel = ProfileViewModel(accountID: AppClient.shared().id)

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
                        self.accountInfo.refreshProfileStatuses()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.isShowing = false
                        }
                    }
            }

        } else {
            self.view
                .navigationBarSearch(self.$searchText, placeholder: "Search for content in this profile...")
                .pullToRefresh(isShowing: $isShowing) {
                    self.accountInfo.refreshProfileStatuses()
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
        List {

            #if os(iOS)
            if self.searchText == "" {
                ProfileViewHeader(accountInfo: self.accountInfo)

                StatusList(self.accountInfo.statuses, context: .none,
                           action: { currentStatus in
                            self.accountInfo.updateProfileStatuses(currentItem: currentStatus)
                           }
                )
                    .padding(.trailing, 20)

            } else {
                StatusList(self.accountInfo.statuses.filter { $0.content.localizedStandardContains(searchText)},
                           context: .none
                )
                    .padding(.trailing, 20)
                    .animation(.spring())
            }

            #else
            ProfileViewHeader(accountInfo: self.accountInfo)

            StatusList(self.accountInfo.statuses, context: .none,
                       action: { currentStatus in
                        self.accountInfo.updateProfileStatuses(currentItem: currentStatus)
                       }
            )
                .padding(.trailing, 20)
            #endif

        }
            .listRowInsets(EdgeInsets())
            .onAppear {
                self.accountInfo.fetchProfile()

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.accountInfo.fetchProfileStatuses()
                })
            }

            // swiftlint:disable:next line_length
            .navigationTitle("\(self.accountInfo.data?.id == AppClient.shared().id ? "You" : (self.accountInfo.data?.displayName ?? "Profile")) - \((self.accountInfo.data?.statusesCount ?? 0).roundedWithAbbreviations) toots")
            .navigationBarTitleDisplayMode(.inline)
    }

}

struct ProfileViewBanner: View {

    @State var header: String?
    @State var avatar: String?
    @Binding var isEditing: Bool

    var body: some View {

        if let header = self.header {
            URLImage(URL(string: header)!,
                     placeholder: { _ in
                        Rectangle()
                            .frame(height: 200)
                            .foregroundColor(.gray)
                            .overlay(
                                self.avatarImage.offset(y: 64),
                                alignment: .bottomLeading
                            )
                     },
                     content: {
                        $0.image
                            .asBanner()
                            .overlay(isEditing ?
                                        AnyView(
                                            ZStack {
                                                Rectangle().foregroundColor(.black).opacity(0.3)
                                                Button(action: {}, label: {
                                                    Image(systemName: "photo.on.rectangle.angled")
                                                        .imageScale(.large)
                                                        .foregroundColor(.white)
                                                })
                                            }
                                        ): AnyView(EmptyView()),
                                     alignment: .center
                            )
                            .overlay(
                                self.avatarImage.offset(y: 64),
                                alignment: .bottomLeading
                            )
                     })
                .padding(.top, -5)
                .animation(.spring())
        } else {
            Rectangle()
                .frame(height: 200)
                .foregroundColor(.gray)
                .overlay(
                    Image("amodrono")
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 100, height: 100)
                        .redacted(reason: .placeholder)
                        .padding()
                        .background(
                            Circle()
                                .frame(width: 110, height: 110)
                                .foregroundColor(backgroundColor)
                        )
                        .offset(y: 64),
                    alignment: .bottomLeading
                )
        }

    }

    var avatarImage: some View {
        URLImage(URL(string: self.avatar!)!,
            placeholder: { _ in
                Image("amodrono")
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 100, height: 100)
                    .redacted(reason: .placeholder)
            },
            content: {
                $0.image
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 100, height: 100)
                    .overlay(isEditing ?
                            AnyView(
                                ZStack {
                                    Circle().foregroundColor(.black).opacity(0.3)
                                    Button(action: {}, label: {
                                            Image(systemName: "photo.on.rectangle.angled")
                                                .imageScale(.large)
                                                .foregroundColor(.white)
                                    })
                                }
                            ): AnyView(EmptyView()),
                        alignment: .center
                    )
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

    @State var infoShown: [ProfileViewInfo] = [.fields, .dateCreated]
    @State var isEditing: Bool = false
    @State var userNote: String = ""

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

            ProfileViewBanner(
                header: self.accountInfo.data?.headerStatic,
                avatar: self.accountInfo.data?.avatarStatic,
                isEditing: self.$isEditing
            )
                .padding(.horizontal, -20)

            if self.accountInfo.data != nil {
                header
            } else {
                placeholder
                    .redacted(reason: .placeholder)
            }
        }
            .buttonStyle(PlainButtonStyle())
    }

    var header: some View {
        VStack(alignment: .leading) {

            HStack {
                Spacer()
                if self.accountInfo.accountID == AppClient.shared().id {
                    Button(action: {
                        self.userNote = self.accountInfo.data!.note
                        withAnimation(.spring()) {
                            self.isEditing.toggle()
                        }
                    }, label: {
                        Text(isEditing ? "Stop editing \(Image(systemName: "xmark"))" : "Edit \(Image(systemName: "pencil"))")
                            .font(.callout)
                            .foregroundColor(.purple)
                            .bold()
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.purple, lineWidth: 2)
                            )
                    })
                } else {

                    Button(action: {
                        print("tapped!")
                    }, label: {
                        Text("Follow \(Image(systemName: "person.fill.badge.plus"))")
                            .font(.callout)
                            .foregroundColor(.white)
                            .bold()
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(Color.blue.cornerRadius(5))
                    })

                }
            }
                .padding(.top, 10)

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

                // swiftlint:disable no_space_in_method_call multiple_closures_with_trailing_closure
                Menu {
                    if let data = accountInfo.data {
                        Text("Date created: \(data.createdAt.getDate()!.format(as: "EEEE, dd MMMM YYYY")) at \(data.createdAt.getDate()!.format(time: .medium))")
                    }
                    Divider()
                    Button(action: {
                        openShareSheet(url: URL(string: self.accountInfo.data!.url)!)
                    }, label: {Text("Share \(Image(systemName: "square.and.arrow.up"))")})
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
                    .padding(.trailing)
                // swiftlint:enable no_space_in_method_call multiple_closures_with_trailing_closure

            }

            Text("@\((accountInfo.data?.acct)!)")
                .font(.callout)
                .foregroundColor(.secondary)

            VStack {
                if self.isEditing {
                    TextField("", text: self.$userNote)
                } else {
                    if self.accountInfo.data!.note.isEmpty || self.accountInfo.data!.note == "" {
                        Text("Apparently, this user prefers to keep an air of mystery about them... 👻")
                            .fixedSize()
                    } else {
                        VStack(alignment: .leading) {
                            AttributedTextView(
                                attributedText: "\((accountInfo.data?.note)!)"
                                    .style(tags: rootStyle)
                                    .styleLinks(linkStyle)
                                    .styleHashtags(linkStyle)
                                    .styleMentions(linkStyle),
                                configured: { label in
                                    self.configureLabel(label, size: 20)
                                },
                                maxWidth: bounds - padding)
                            .fixedSize()
                        }
                    }
                }

            }
                .animation(.spring())

            if infoShown.contains(.dateCreated) {
                Text("Joined \(self.accountInfo.data!.createdAt.getDate()!.format(as: "MMMM YYYY"))")
                    .foregroundColor(.gray)
                    .font(.callout)
            }

            if infoShown.contains(.fields) {
                FieldList(fields: self.accountInfo.data?.fields ?? [])
                    .frame(width: bounds - 40)
            } else {
                Divider()
            }

            self.stats
                .padding(.horizontal, -20)

        }
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

                // swiftlint:disable no_space_in_method_call multiple_closures_with_trailing_closure
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
                // swiftlint:enable no_space_in_method_call multiple_closures_with_trailing_closure

            }

            Text("@\(accountInfo.data?.acct ?? "user")")
                .font(.callout)
                .foregroundColor(.secondary)

            Text("""
                This is an example bio/note that will be displayed as a placeholder until the actual bio/note is loaded.
                """)

            Text("Joined Mar 2016")
                .foregroundColor(.gray)
                .font(.callout)

            Divider()

            self.statsPlaceholder
                .padding(.leading, -5)

        }
            .padding(.top, 40)
    }

    var stats: some View {
        HStack {

            Spacer()

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

//            VStack {
//
//                Text("\((accountInfo.data?.statusesCount.roundedWithAbbreviations)!)")
//                    .font(.system(size: 20, weight: .semibold, design: .rounded))
//
//                Text("Toots \(Image(systemName: "doc.richtext"))")
//                    .fontWeight(.semibold)
//
//            }

        }
    }

    var statsPlaceholder: some View {
        VStack {
            HStack {

                Spacer()

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
