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
struct StatusView: View {

    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif

    /// In Starlight, there are two ways to display mastodon statuses:
    ///     - Standard: The status is being displayed from the feed.
    ///     - Focused: The status is the main post of a thread.
    ///
    /// The ``StatusView`` instance should know what way it is being
    /// displayed so that it can display the content properly.
    /// In order to achieve this, we pass a bool to ``StatusView``, which when true,
    /// tells it that it's content should be displayed as `Focused`.
    private var isMain: Bool

    /// The ``Status`` data model whose the data will be displayed.
    var status: Status

    #if os(iOS)

    /// Using for triggering the navigation View **only**when the user taps
    /// on the content, and not when it taps on the action buttons.
    @State var goToThread: Int? = 0

    @State var showMoreActions: Bool = false

    @State var profileViewActive: Bool = false

    #endif

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

    // MARK: BODY

    /// To easily use the same view on multiple platforms,
    /// we use the `body` view as a container where we load platform-specific
    /// modifiers.
    var body: some View {

        //  We use this vertical stack to load platform specific modifiers,
        //  or to load specific views when a condition is met.
        VStack {

            // Whether the post is focused or not.
            if self.isMain {

                self.presentedView

            } else {

                // To provide the best experience, we want to allow the user to easily
                // interact with a post directly from the feed. Because of that, we need
                // to add a button
                ZStack {

                    self.defaultView

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

        }
            .buttonStyle(PlainButtonStyle())

    }

    // MARK: PRESENTED VIEW
    /// The status display mode when it is the thread's main post.
    var presentedView: some View {

        VStack(alignment: .leading) {

            NavigationLink(destination:
                            ProfileView(isParent: false,
                                        accountInfo: ProfileViewModel(accountID: self.status.account.id),
                                        onResumeToParent: {
                                            self.profileViewActive = false
                                        }),
                           isActive: self.$profileViewActive) {
                EmptyView()
            }

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

                Button(action: { self.showMoreActions.toggle() }, label: {
                    Image(systemName: "ellipsis")
                        .imageScale(.large)
                })
            }

            self.statusContent

            if !self.status.mediaAttachments.isEmpty {
                AttachmentView(from: self.status.mediaAttachments[0].url) {
                    Rectangle()
                        .scaledToFit()
                        .cornerRadius(10)
                }
            }

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

            Divider()

            self.actionButtons
                .padding(.vertical, 5)
                .padding(.horizontal)

        }
            .buttonStyle(PlainButtonStyle())
        .navigationBarHidden(self.profileViewActive)
        .actionSheet(isPresented: self.$showMoreActions) {
            ActionSheet(title: Text("More Actions"),
                        buttons: [
                            .default(Text("View @\(self.status.account.acct)'s profile"), action: {
                                self.profileViewActive = true
                            }),
                            .destructive(Text("Mute @\(self.status.account.acct)"), action: {

                            }),
                            .destructive(Text("Block @\(self.status.account.acct)"), action: {

                            }),
                            .destructive(Text("Report @\(self.status.account.acct)"), action: {

                            }),
                            .cancel(Text("Dismiss"), action: {})
                        ]
            )
        }

    }

    // MARK: DEFAULT VIEW
    var defaultView: some View {

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

                        self.statusContent

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

            self.actionButtons
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

    // MARK: STATUS CONTENT
    /// The post's main content.
    var statusContent: some View {
        #if os(macOS)
        // Note: Need to subtract sidebar size here.
        let bounds: CGFloat = NSApplication.shared.mainWindow?.frame.width
        #else
        let bounds: CGFloat = UIScreen.main.bounds.width
        #endif

        let padding: CGFloat = 84

        return VStack(alignment: .leading) {
            AttributedTextView(
                attributedText: self.status.content
                    .style(tags: isMain ? rootPresentedStyle: rootStyle)
                    .styleLinks(linkStyle)
                    .styleHashtags(linkStyle)
                    .styleMentions(linkStyle),
                configured: { label in
                    self.configureLabel(label, size: isMain ? 20 : 17)
                },
                maxWidth: bounds - padding)
            .fixedSize()
        }
    }

    // MARK: ACTION BUTTONS

    /// The post's action buttons (favourite and reblog), and also the amount of replies.
    ///
    /// If the post is focused (``isMain`` is true), the count is hidden.
    var actionButtons: some View {
        HStack {

            HStack {

                Image(systemName: "text.bubble")

                if !self.isMain {
                    Text("\(self.status.repliesCount.roundedWithAbbreviations)")
                }

            }

            Spacer()

            Button(action: {

            }, label: {

                HStack {

                    Image(systemName: "arrow.2.squarepath")

                    if !self.isMain {
                        Text("\(self.status.reblogsCount.roundedWithAbbreviations)")
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
                        Text("\(self.status.favouritesCount.roundedWithAbbreviations)")
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

// MARK: EXTENSIONS
extension StatusView {

    /// Generates a View that displays a post on Mastodon.
    ///
    /// - Parameters:
    ///     - isPresented: A boolean variable that determines whether
    ///     the status is being shown as the main post (in a thread).
    ///     - status: The identified data that the ``StatusView`` instance uses to
    ///     display posts dynamically.
    public init(isMain: Bool = false, status: Status) {
        self.isMain = isMain
        self.status = status
    }

}

struct StatusView_Previews: PreviewProvider {

    @ObservedObject static var timeline = NetworkViewModel()

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
                StatusView(isMain: false, status: self.timeline.statuses[0])
            }
        }
            .frame(width: 600, height: 300)
            .previewLayout(.sizeThatFits)
    }
}
