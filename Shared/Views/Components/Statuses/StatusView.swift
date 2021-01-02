//
//  StatusView.swift
//  Codename Starlight
//
//  Created by Alejandro Modroño Vara on 09/07/2020.
//
// swiftlint:disable file_length

#if os(macOS)
import AppKit
#endif

import SwiftUI
import Atributika
import URLImage
import SwipeCell
import Introspect

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
    private var displayMode: StatusConfiguration.DisplayMode

    /// The ``Status`` data model we're displaying.
    var status: Status?

//    @State var context: StatusViewConfiguration.Context

    @StateObject var manager = StatusConfiguration.BindingManager()

    var body: some View {

        VStack {

            if let status = self.status {

                if self.displayMode == .presented {
                    PresentedStatusView(
                        status: status,
                        manager: self.manager
                    )
                } else { // displayMode is .compact
                    CompactStatusView(
                        status: status,
                        manager: self.manager
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
    public init(_ displayMode: StatusConfiguration.DisplayMode = .compact, status: Status? = nil) {
        self.displayMode = displayMode
        self.status = status
    }

}

/// The status' content.
private struct StatusViewContent: View {

    let isMain: Bool
    let content: String
    let card: Card?
    let attachments: [Attachment]

    @State var redraw: Bool = false

    @Binding var page: StatusConfiguration.BindingManager.Page

    // MARK: STATUS VIEW TEXT STYLES
    private let rootStyle: Style = Style("p")
        .font(.systemFont(ofSize: 16, weight: .regular))
    private let rootPresentedStyle: Style = Style("p")
        .font(.systemFont(ofSize: 20, weight: .light))
    private let linkStyle: Style = Style("a")
        .foregroundColor(#colorLiteral(red: 0.6050000191, green: 0.3829999864, blue: 1, alpha: 1))

    /// Configure the label to match the styling for the status.
    private func configureLabel(_ label: AttributedLabel, size: CGFloat = 17) {
        label.numberOfLines = 0
        label.textColor = .label
        label.lineBreakMode = .byWordWrapping
        label.onClick = { _, detection in
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
        // Note: Need to subtract sidebar size here.
        let bounds: CGFloat = NSApplication.shared.mainWindow?.frame.width
        #else
        let bounds: CGFloat = UIScreen.main.bounds.width
        #endif

        return VStack(alignment: .leading) {
            ZStack {
                AttributedTextView(
                    attributedText: self.content.stripHTML()
                        .style(tags: isMain ? rootPresentedStyle: rootStyle)
                        .styleLinks(linkStyle)
                        .styleHashtags(linkStyle)
                        .styleMentions(linkStyle),
                    configured: { label in
                        self.configureLabel(label, size: isMain ? 20 : 17)
                    },
                    maxWidth: isMain ? bounds - 30 : bounds  - 90)
                    .fixedSize()
                Spacer()
            }

            if !self.attachments.isEmpty {
                RemoteGalleryView(data: self.attachments)
            }

            if let card = self.card {
                CardView(card: card, isMain: self.isMain)
            }

        }
    }

}

/// The status is being displayed in a ``StatusList``, so we should make it smaller and more compact.
private struct CompactStatusView: View {

    /// The ``Status`` data model from where we obtain all the data.
    var status: Status

    @ObservedObject var manager: StatusConfiguration.BindingManager

    var body: some View {
        self.content
            .padding(.vertical, 5)
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
            .buttonStyle(PlainButtonStyle())
            .background(
                NavigationLink(
                    destination: self.destination(status: self.status),
                    isActive: self.$manager.navLinkActive
                ) {
                    EmptyView()
                }
            )
    }

    @ViewBuilder
    public func destination(status: Status) -> some View {

        switch self.manager.currentPage {
        case .thread(identifier: _, status: let status):
            ThreadView(mainStatus: status!)
        case .profile(identifier: let identifier, account: _):
            ProfileView(viewModel: AccountViewModel(accountID: identifier!), isParent: false)
        case .default:
            ThreadView(mainStatus: status)
        }

    }

    var content: some View {
        HStack(alignment: .top, spacing: 12) {

            URLImage(URL(string: self.status.account.avatarStatic)!,
                placeholder: { _ in
                    Image("amodrono")
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 50, height: 50)
                        .redacted(reason: .placeholder)
                },
                content: { proxy in
                    Button(action: {
                        self.manager.currentPage = .profile(identifier: self.status.account.id)
                    }, label: {
                        proxy.image
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 50, height: 50)
                    })
                }
            )

            VStack(alignment: .leading, spacing: 2) {
                HStack(alignment: .firstTextBaseline) {

                    Group {
                        if !self.status.account.displayName.isEmpty {
                            Text("\(self.status.account.displayName)")
                                .font(.headline)
                                .loadUsernameColor(identifier: self.status.account.id)
                                .lineLimit(1)
                        }

                        Text("@\(self.status.account.acct)")
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                        .onTapGesture {
                            self.manager.currentPage = .profile(identifier: self.status.account.id)
                        }

                    Text("· \(self.status.createdAt.getDate()!.getInterval())")
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }

                StatusViewContent(
                    isMain: false,
                    content: self.status.content,
                    card: self.status.card,
                    attachments: self.status.mediaAttachments,
                    page: self.$manager.currentPage
                )

                StatusActionButtons(
                    isMain: false,
                    repliesCount: self.status.repliesCount,
                    reblogsCount: self.status.reblogsCount,
                    favouritesCount: self.status.favouritesCount,
                    statusUrl: self.status.uri
                )

            }

            Spacer()
        }
    }

}

/// The status is the main post in the thread, so we should make it bigger.
private struct PresentedStatusView: View {

    var status: Status

    @ObservedObject var manager: StatusConfiguration.BindingManager

    @State var redraw: Bool = false

    var body: some View {

        VStack(alignment: .leading) {

            HStack(alignment: .top) {

                URLImage(URL(string: self.status.account.avatarStatic)!,
                    placeholder: { _ in
                        Image("amodrono")
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 50, height: 50)
                            .redacted(reason: .placeholder)
                    },
                    content: { proxy in
                        Button(action: {
                            self.manager.currentPage = .profile(identifier: self.status.account.id)
                        }, label: {
                            proxy.image
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .frame(width: 50, height: 50)
                        })
                            .background(
                                NavigationLink(
                                    destination: self.destination(),
                                    isActive: self.$manager.navLinkActive
                                ) {
                                    EmptyView()
                                }
                            )
                    }
                )

                VStack(alignment: .leading, spacing: 5) {

                    VStack(alignment: .leading) {

                        if !self.status.account.displayName.isEmpty {
                            Text("\(self.status.account.displayName)")
                                .loadUsernameColor(identifier: self.status.account.id)
                                .font(.headline)
                        }

                        Text("@\(self.status.account.acct)")
                            .foregroundColor(.gray)
                            .lineLimit(1)

                    }

                }

                Spacer()

                Menu {
                    Button("View @\(self.status.account.acct)'s profile", action: {
                        self.manager.currentPage = .profile(identifier: self.status.account.id)
                    })
                    Button("Mute @\(self.status.account.acct)", action: {})
                    Button("Block @\(self.status.account.acct)", action: {})
                    Button("Report @\(self.status.account.acct)", action: {})
                    Button("Dismiss", action: {})
                } label: {
                    Image(systemName: "ellipsis")
                        .imageScale(.large)
                }
                    .padding()
                // swiftlint:enable no_space_in_method_call multiple_closures_with_trailing_closure
            }

            StatusViewContent(
                isMain: true,
                content: self.status.content,
                card: self.status.card,
                attachments: self.status.mediaAttachments,
                page: self.$manager.currentPage
            )

            self.footer

        }
            .buttonStyle(PlainButtonStyle())

    }

    @ViewBuilder
    public func destination() -> some View {

        switch self.manager.currentPage {
        case .thread(identifier: _, status: let status):
            ThreadView(mainStatus: status!)
        case .profile(identifier: let identifier, account: _):
            ProfileView(viewModel: AccountViewModel(accountID: identifier!), isParent: false)
        case .default:
            EmptyView()
        }

    }

    var footer: some View {
        VStack(alignment: .leading) {
            HStack {
                // swiftlint:disable:next line_length
                Text("\(self.status.createdAt.getDate()!.format(time: .short)) · \(self.status.createdAt.getDate()!.format(date: .short)) · ")
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

            VStack {
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
            }

            Divider()

            StatusActionButtons(
                isMain: true,
                repliesCount: self.status.repliesCount,
                reblogsCount: self.status.reblogsCount,
                favouritesCount: self.status.favouritesCount,
                statusUrl: self.status.uri
            )
                .padding(.vertical, 5)
                .padding(.horizontal)
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
    let statusUrl: String

    var body: some View {

        HStack {

            Button(  // swiftlint:disable:next line_length
                "\(self.isMain ? Image(systemName: "arrowshape.turn.up.left") : Image(systemName: "bubble.right")) \(self.isMain ? "" : self.repliesCount.roundedWithAbbreviations)",
                action: {
                    if self.isMain {
                        print("Opening composer...")
                    }
                }
            )

            Spacer()

            Button(  // swiftlint:disable:next line_length
                "\(Image(systemName: "arrow.2.squarepath")) \(self.isMain ? "" : self.reblogsCount.roundedWithAbbreviations)",
                action: {}
            )

            Spacer()

            Button(
                "\(Image(systemName: "heart")) \(self.isMain ? "" : self.favouritesCount.roundedWithAbbreviations)",
                action: {}
            )

            Spacer()

            Button(
                "\(Image(systemName: "square.and.arrow.up"))",
                action: {
                    #if os(iOS)
                    openShareSheet(url: URL(string: self.statusUrl)!)
                    #endif
                }
            )

            if !isMain {
                Spacer()
            }

        }
            .if(!isMain) {
                $0.padding(.top, 12)
            }
            .if(isMain) {
                $0.font(.title3)
            }
            .foregroundColor(.secondary)
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

extension Text {
    func loadUsernameColor(identifier: String) -> Text {

        let devs = [
            "329742",   // amodrono@mastodon.technology
            "367895"    // alicerunsonfedora
        ]

        let testAccts = [
            "724754" // Starlight Alpha
        ]

        if devs.contains(identifier) {
            return self.foregroundColor(.red)
        } else if testAccts.contains(identifier) {
            return self.foregroundColor(.orange)
        } else if identifier == "1" {
            return self.foregroundColor(.purple)
        } else {
            return self.foregroundColor(labelColor)
        }

    }
}

struct StatusView_Previews: PreviewProvider {

    @StateObject static var timeline = TimelineViewModel()

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
            } else {
                StatusView(StatusConfiguration.DisplayMode.compact, status: self.timeline.statuses[0])
            }
        }
            .frame(width: 600, height: 300)
            .previewLayout(.sizeThatFits)
    }
}
