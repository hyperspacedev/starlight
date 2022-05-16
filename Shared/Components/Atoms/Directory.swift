//
//  Directory.swift
//  Starlight
//
//  Created by Marquis Kurt on 23/10/21.
//

import SwiftUI
import Chica

/// A list section that shows people in the directory.
struct Directory: View, InternalStateRepresentable {

    /// An enumeration that represents the context for the section.
    enum Context {

        /// The context will show new arrivals in the community.
        case newArrivals

        /// The context will show accounts who have been active recently.
        case popular
    }

    /// The context for this section.
    @State var context: Context

    /// Whether to search only in the local scope. Defaults to true.
    @State var localOnly: Bool = true

    @State internal var state: ViewState = .initial
    @State private var directory: [Account]?

    /// The main view of the directory.
    var body: some View {
        Section(sectionTitle) {
            Group {
                switch state {
                case .initial, .loading:
                    ForEach(0..<5) { _ in
                        Text("misc.placeholder")
                    }
                    .redacted(reason: .placeholder)
                case .loaded, .updated:
                    self.directoryList
                case .errored(let reason):
                    StackedLabel(systemName: "exclamation.mark", title: "Failed to Load Data") {
                        Text(reason)
                    }
                }
            }
        }
        .onAppear { loadData() }
    }

    private var directoryList: some View {
        Group {
            if let accounts = directory {
                ForEach(accounts, id: \.id) { account in
                    NavigationLink(destination: ProfileView(context: .user(id: account.id))) {
                        entry(for: account)
                    }
                }
            }
        }
    }

    private var sectionTitle: LocalizedStringKey {
        switch context {
        case .newArrivals:
            return "explore.directory.arrivals"
        case .popular:
            return "explore.directory.popular"
        }
    }

    private func entry(for account: Account) -> some View {
        HStack(spacing: 8) {
            ProfileImage(for: .user(id: account.id), size: .medium)
            VStack(alignment: .leading) {
                Text(account.getName().emojified())
                    .bold()
                if context == .newArrivals {
                    Text(account.createdAt.toMastodonDate() ?? .now, format: .relative(presentation: .named))
                } else {
                    Text("\(account.statusesCount) statuses written")
                }
            }
        }
    }

    internal func loadData() {
        Task.init {
            state = .loading
            do {
                try await getDirectory()
                state = .loaded
            } catch {
                state = .errored(reason: "")
            }
        }
    }

    private func getDirectory() async throws {
        if directory?.isEmpty == false { return }
        let ordering = context == .newArrivals ? "new" : "active"
        directory = try await Chica.shared.request(
            .get, for: .directory, body: ["local": "true", "limit": "5", "order": ordering])
    }
}

struct Directory_Previews: PreviewProvider {
    static var previews: some View {
        Directory(context: .newArrivals)
    }
}
