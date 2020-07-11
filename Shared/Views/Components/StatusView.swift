//
//  StatusView.swift
//  Codename Starlight
//
//  Created by Alejandro Modroño Vara on 09/07/2020.
//

import SwiftUI

/// Displays a status model.
///
/// - Parameters:
///     - isPresented: Whether the status is being shown as the main post (in a thread).
///     - status: The status data model for loading the data.
struct StatusView: View {

    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif

    /// Whether the status is being shown as the main post (in a thread).
    var isPresented: Bool = false

    #if os(iOS)

    /// Using for triggering the navigation View **only**when the user taps
    /// on the content, and not when it taps on the action buttons.
    @State var goToThread: Int? = 0

    #endif

    /// The primary view.
    var body: some View {

        /*
        *   We use this vertical stack to load platform specific modifiers,
        *   or to load specific views when a condition is met.
        */
        VStack {

            if self.isPresented {

                self.presentedView

            } else {

                #if os(iOS)
                ZStack {

                    Button(action: {
                        self.goToThread = 1
                    }, label: {
                        self.defaultView
                    })

                    NavigationLink(destination: ThreadView(), tag: 1, selection: self.$goToThread, label: {
                        EmptyView()
                    })

                }
                #else
                NavigationLink(destination: ThreadView(), label: {
                    self.defaultView
                })
                #endif

            }

        }

    }

    var presentedView: some View {

        VStack(alignment: .leading) {

            HStack(alignment: .center) {

                Image("amodrono")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 50)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 5) {

                    VStack(alignment: .leading) {

                        Text("Hello, World!")
                            .font(.headline)

                        Text("@amodrono@mastodon.social")
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

            Text("This view shows how Mastodon statuses will look on cells. It also has some random text so that I can see how big content looks.")
                .font(.system(size: 20, weight: .light))

            HStack {
                Text("07:56 · 9/7/2020 · ")
                Button(action: {}, label: {
                    Text("Starlight for iOS")
                })
                    .foregroundColor(.accentColor)
                    .padding(.leading, -5)
            }
                .padding(.top)

            Divider()

            Text("79 ").bold()
            +
            Text("comments, ")
            +
            Text("20 ").bold()
            +
            Text("boosts, and ")
            +
            Text("20k ").bold()
            +
            Text("likes.")

            Divider()

            self.actionButtons
                .padding(.vertical, 5)
                .padding(.horizontal)

        }

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

                            Text("Hello, World!")
                                .font(.headline)

                            Text("@amodrono@mastodon.social")
                                .foregroundColor(.gray)
                                .lineLimit(1)

                        }

                        Spacer()

                        Text("· 24s")

                    }

                    Text("This view shows how Mastodon statuses will look on cells. It also has some random text so that I can see how big content looks.")
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
                    Text("79")
                }

            }

            Spacer()

            Button(action: {

            }, label: {

                HStack {

                    Image(systemName: "arrow.2.squarepath")

                    if !self.isPresented {
                        Text("20")
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
                        Text("20k")
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

struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
        StatusView(isPresented: true)
    }
}
