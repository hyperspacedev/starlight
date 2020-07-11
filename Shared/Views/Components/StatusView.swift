//
//  StatusView.swift
//  Codename Starlight
//
//  Created by Alejandro Modroño Vara on 09/07/2020.
//

import SwiftUI

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
    var isPresented: Bool

    /// The ``Status`` data model whose the data will be displayed.
    var status: Status

    #if os(iOS)

    /// Using for triggering the navigation View **only**when the user taps
    /// on the content, and not when it taps on the action buttons.
    @State var goToThread: Int? = 0

    #endif

    /// To provide the best experience on multiple platforms,
    /// we use the `body` view as a container where we load platform-specific
    /// modifiers.
    var body: some View {

        //  We use this vertical stack to load platform specific modifiers,
        //  or to load specific views when a condition is met.
        VStack {

            // Whether the post is focused or not.
            if self.isPresented {

                self.presentedView

            } else {

                // To provide the best experience, we want to allow the user to easily
                // interact with a post directly from the feed. Because of that, we need
                // to add a button
                ZStack {

                    self.defaultView

                    NavigationLink(destination: ThreadView(mainStatus: self.status), tag: 1, selection: self.$goToThread, label: {
                        EmptyView()
                    })

                }

            }

        }

    }

    var presentedView: some View {

        VStack(alignment: .leading){

            HStack(alignment: .center) {

                Image("amodrono")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 50)
                    .clipShape(Circle())

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

                Button(action: {}, label: {
                    Image(systemName: "ellipsis")
                        .imageScale(.large)
                })

            }

            Text("\(self.status.content)")
                .font(.system(size: 20, weight: .light))

            HStack {
                Text("\(self.status.createdAt) · ")
                Button(action: {}, label: {
                    Text("\(self.status.application?.name ?? "Mastodon")")
                })
                    .foregroundColor(.accentColor)
                    .padding(.leading, -5)
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
//            .buttonStyle(PlainButtonStyle())

    }

    var defaultView: some View {

        VStack(alignment: .leading) {

            HStack(alignment: .top) {

                Image("amodrono")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 50)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 5) {

                    HStack {

                        HStack(spacing: 5) {

                            Text("\(self.status.account.displayName)")
                                .font(.headline)
                                .lineLimit(1)

                            Text("\(self.status.account.acct)")
                                .foregroundColor(.gray)
                                .lineLimit(1)

                        }

                        Spacer()

                        Text("· 24s")

                    }

                    Text("\(self.status.content)")
                        .fontWeight(.light)

                    self.actionButtons
                        .padding(.top)

                }

            }

        }

    }

    var actionButtons: some View {
        HStack {

            HStack {

                Image(systemName: "text.bubble")

                if !self.isPresented {
                    Text("\(self.status.repliesCount.roundedWithAbbreviations)")
                }

            }

            Spacer()

            Button(action: {

            }, label: {

                HStack {

                    Image(systemName: "arrow.2.squarepath")

                    if !self.isPresented {
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

                    if !self.isPresented {
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

extension StatusView {

    /// Generates a View that retrieves image data from a remote URL
    /// (usually decoded from JSON), that automatically changes across updates;
    /// and caches it.
    ///
    /// It's important that `content` makes use of the escaping closure to display the image,
    /// or else anything will be displayed. If a problem occurs while retrieving the data, an
    /// error message will be provided. You should log that and maybe show a simple message to the user.
    ///
    /// - Parameters:
    ///     - isPresented: A boolean variable that determines whether
    ///     the status is being shown as the main post (in a thread).
    ///     - status: The identified data that the ``StatusView`` instance uses to
    ///     display posts dynamically.
    public init(isPresented: Bool = false, status: Status) {
        self.isPresented = isPresented
        self.status = status
    }

}

struct StatusView_Previews: PreviewProvider {

    @ObservedObject static var timeline = TimelineViewModel()

    static var previews: some View {
        StatusView(isPresented: true, status: self.timeline.statuses[0])
    }
}
