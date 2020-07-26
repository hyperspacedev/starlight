//
//  StatusView.swift
//  Codename Starlight
//
//  Created by Alejandro Modroño Vara on 09/07/2020.
//

#if os(macOS)
import AppKit
#endif

import SwiftUI
import Atributika

/// A structure that computes statuses on demand from a `Status` data model.
///
/// For the sake of having a cleaner code, Starlight's status view is divided
/// into several sub-components, such as ``CompactStatusView`` and ``PresentedStatusView``,
/// which then divide themselves into smaller sub-components.
struct StatusView: View {

    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif

    /// In Starlight, there are two ways to display mastodon statuses:
    ///     - Compact: The status is being displayed from a list.
    ///     - Presented: The status is the main post in a thread.
    ///
    /// The ``StatusView`` instance should know what way it is being
    /// displayed so that it can display the content properly.
    /// In order to achieve this, we pass a bool to ``StatusView``, which when true,
    /// tells it that it's content should be displayed as `Focused`.
    ///
    ///
    private var displayMode: StatusDisplayMode

    /// The ``Status`` data model we're displaying.
    var status: Status?

    #if os(iOS)

    /// Used for triggering the navigation View **only** when the user taps
    /// on the content, and not when it taps on the action buttons.
    @State var goToThread: Int? = 0

    /// Used for redirecting the user to the author's profile.
    @State var profileViewActive: Bool = false

    #endif

    var body: some View {

        VStack {

            if let status = self.status {

                if self.displayMode == .presented {
                    PresentedStatusView(
                        status: status,
                        profileViewActive: self.$profileViewActive
                    )
                } else { // displayMode is .compact
                    CompactStatusView(
                        status: status,
                        goToThread: self.$goToThread
                    )
                }

            } else {
                PlaceholderStatusView()
            }

        }
            .buttonStyle(PlainButtonStyle())

    }

}

// MARK: EXTENSIONS
extension StatusView {

    /// Generates a View that displays a post on Mastodon.
    ///
    /// - Parameters:
    ///     - displayMode: How should the status be displayed.
    ///     - status: The identified data that the ``StatusView`` instance uses to
    ///     display posts dynamically.
    public init(_ displayMode: StatusDisplayMode = .compact, status: Status? = nil) {
        self.displayMode = displayMode
        self.status = status
    }

}

/// The status' content.
private struct StatusViewContent: View {

    let isMain: Bool
    let content: String

    // MARK: STATUS VIEW TEXT STYLES
    private let rootStyle: Style = Style("p")
        .font(.systemFont(ofSize: 17, weight: .light))
    private let rootPresentedStyle: Style = Style("p")
        .font(.systemFont(ofSize: 20, weight: .light))
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

    var body: some View {

        #if os(macOS)
        if self.isMain {
            // Note: Need to subtract sidebar size here.
            let bounds: CGFloat = NSApplication.shared.mainWindow?.frame.width
        } else {
            // Note: Need to subtract sidebar size here.
            let bounds: CGFloat = NSApplication.shared.mainWindow?.frame.width
        }
        #else
        let bounds: CGFloat = UIScreen.main.bounds.width
        #endif

        return VStack(alignment: .leading) {
            AttributedTextView(
                attributedText: self.content
                    .style(tags: isMain ? rootPresentedStyle: rootStyle)
                    .styleLinks(linkStyle)
                    .styleHashtags(linkStyle)
                    .styleMentions(linkStyle),
                configured: { label in
                    self.configureLabel(label, size: isMain ? 20 : 17)
                },
                maxWidth: isMain ? bounds - 30 : bounds  - 84)
            .fixedSize()
        }
    }

}

/// The status is being displayed in a ``StatusList``, so we should make it smaller and more compact.
private struct CompactStatusView: View {

    var status: Status

    @Binding var goToThread: Int?

    var body: some View {

        //  We want users to be able to quickly interact with posts without needing to open
        //  the post.
        //
        //  It's a bit hacky, yeah, but it works, so... ¯\_(ツ)_/¯
        ZStack {

            self.content

            NavigationLink(
                destination: ThreadView(mainStatus: self.status),
                tag: 1,
                selection: self.$goToThread,
                label: {
                    EmptyView()
                }
            )

        }

    }

    var content: some View {

        VStack(alignment: .leading) {

            Button(action: {
                self.goToThread = 1
            }, label: {
                HStack(alignment: .top) {

                    ProfileImage(from: self.status.account.avatarStatic, placeholder: {
                        Circle()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                    })

                    VStack(alignment: .leading, spacing: 5) {

                        HStack {

                            HStack(spacing: 5) {

                                Text("\(self.status.account.displayName)")
                                    .font(.headline)
                                    .lineLimit(1)

                                Text("\(self.status.account.acct)")
                                    .foregroundColor(.gray)
                                    .lineLimit(1)

                                Text("· \(self.status.createdAt.getDate()!.getInterval())")
                                    .lineLimit(1)

                            }

                        }

                        StatusViewContent(
                            isMain: false,
                            content: self.status.content
                        )

                        if !self.status.mediaAttachments.isEmpty {
                            AttachmentView(from: self.status.mediaAttachments[0].previewURL) {
                                Rectangle()
                                    .scaledToFit()
                                    .cornerRadius(10)
                            }
                        }

                    }

                }
            })

            StatusActionButtons(
                isMain: false,
                repliesCount: self.status.repliesCount,
                reblogsCount: self.status.reblogsCount,
                favouritesCount: self.status.favouritesCount
            )
                .padding(.leading, 60)

        }
            .contextMenu(
                ContextMenu(menuItems: {

                    Button(action: {}, label: {
                        Label("Report post", systemImage: "flag")
                    })

                    Button(action: {}, label: {
                        Label("Report \(self.status.account.displayName)", systemImage: "flag")
                    })

                    Button(action: {}, label: {
                        Label("Share as Image", systemImage: "square.and.arrow.up")
                    })

                })
            )

    }

}

/// The status is the main post in the thread, so we should make it bigger.
private struct PresentedStatusView: View {

    var status: Status
    @Binding var profileViewActive: Bool

    var body: some View {

        VStack(alignment: .leading) {

            NavigationLink(destination:
                            ProfileView(
                                accountInfo: ProfileViewModel(accountID: self.status.account.id),
                                isParent: false
                            ),
                           isActive: self.$profileViewActive) {
                EmptyView()
            }
                .disabled(self.profileViewActive ? false : true)

            HStack(alignment: .center) {

                ProfileImage(from: self.status.account.avatarStatic, placeholder: {
                    Circle()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                })

                VStack(alignment: .leading, spacing: 5) {

                    VStack(alignment: .leading) {

                        Text("\(self.status.account.displayName)")
                            .font(.headline)

                        Text("\(self.status.account.acct)")
                            .foregroundColor(.gray)
                            .lineLimit(1)

                    }

                }

                Spacer()

                Menu {
                    Button("View @\(self.status.account.acct)'s profile", action: {
                        self.profileViewActive = true
                    })
                    Button("Mute @\(self.status.account.acct)", action: {})
                    Button("Block @\(self.status.account.acct)", action: {})
                    Button("Report @\(self.status.account.acct)", action: {})
                    Button("Dismiss", action: {})
                } label: {
                    Image(systemName: "ellipsis")
                        .imageScale(.large)
                }
            }

            StatusViewContent(isMain: true, content: self.status.content)

            if !self.status.mediaAttachments.isEmpty {
                AttachmentView(from: self.status.mediaAttachments[0].url) {
                    Rectangle()
                        .scaledToFit()
                        .cornerRadius(10)
                }
            }

            self.footer

        }
            .buttonStyle(PlainButtonStyle())
            .navigationBarHidden(self.profileViewActive)

    }

    var footer: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(self.status.createdAt.getDate()!.format(as: "hh:mm · dd/MM/YYYY")) · ")
                Button(action: {

                    if let application = self.status.application {
                        if let website = application.website {
                            openUrl(website)
                        }
                    }

                }, label: {
                    Text("\(self.status.application?.name ?? "Mastodon")")
                        .lineLimit(1)
                })
                    .foregroundColor(.accentColor)
                    .padding(.leading, -7)
            }
                .padding(.top)

            Divider()

            Text("\(self.status.repliesCount.roundedWithAbbreviations) ").bold()
            +
            Text("comments, ")
            +
            Text("\(self.status.reblogsCount.roundedWithAbbreviations) ").bold()
            +
            Text("boosts, and ")
            +
            Text("\(self.status.favouritesCount.roundedWithAbbreviations) ").bold()
            +
            Text("likes.")

//            Divider()
//
//            StatusActionButtons(
//                isMain: true,
//                repliesCount: self.status.repliesCount,
//                reblogsCount: self.status.reblogsCount,
//                favoritesCount: self.status.favouritesCount
//            )
//                .padding(.vertical, 5)
//                .padding(.horizontal)
        }
    }

}

/// The post's action buttons (favourite and reblog).
///
/// If the post is focused (``isMain`` is set to `true`), the count is hidden.
private struct StatusActionButtons: View {

    let isMain: Bool
    let repliesCount: Int
    let reblogsCount: Int
    let favouritesCount: Int

    var body: some View {
        HStack {

            HStack {

                Image(systemName: "text.bubble")

                if !self.isMain {
                    Text("\(self.repliesCount.roundedWithAbbreviations)")
                }

            }

            Spacer()

            Button(action: {

            }, label: {

                HStack {

                    Image(systemName: "arrow.2.squarepath")

                    if !self.isMain {
                        Text("\(self.reblogsCount.roundedWithAbbreviations)")
                    }

                }

            })
                .foregroundColor(
                    labelColor
                )

            Spacer()

            Button(action: {

            }, label: {

                HStack {

                    Image(systemName: "heart")

                    if !self.isMain {
                        Text("\(self.favouritesCount.roundedWithAbbreviations)")
                    }
                }

            })
                .foregroundColor(
                    labelColor
                )

            Spacer()

            Button(action: {

            }, label: {

                Image(systemName: "square.and.arrow.up")

            })
                .foregroundColor(
                    labelColor
                )

        }
    }

}

/// A view similar to a compact status view with sample text, and wrapped using `.redacted(reason: .placeholder)`.
private struct PlaceholderStatusView: View {

    var body: some View {
        HStack(alignment: .top) {

            Circle()
                .frame(width: 50, height: 50)
                .foregroundColor(.gray)

            VStack(alignment: .leading, spacing: 5) {

                HStack {

                    HStack(spacing: 5) {

                        Text("Some username")
                            .font(.headline)
                            .lineLimit(1)

                        Text("username@instance")
                            .foregroundColor(.gray)
                            .lineLimit(1)

                        Text("24s")
                            .lineLimit(1)

                    }

                }

                Text("This is a sample mastodon status that is being used as a placeholder.")

            }

        }
            .redacted(reason: .placeholder)
    }

}

struct StatusView_Previews: PreviewProvider {

    @StateObject static var timeline = NetworkViewModel()

    static var previews: some View {
        VStack {
            if self.timeline.statuses.isEmpty {
                HStack {

                    Spacer()

                    VStack {
                        Spacer()
                        ProgressView(value: 0.5)
                            .progressViewStyle(CircularProgressViewStyle())
                        Text("Loading status...")
                        Spacer()
                    }

                    Spacer()

                }
                    .onAppear {
                        self.timeline.fetchTimeline()
                    }
            } else {
                StatusView(.compact, status: self.timeline.statuses[0])
            }
        }
            .frame(width: 600, height: 300)
            .previewLayout(.sizeThatFits)
    }
}
