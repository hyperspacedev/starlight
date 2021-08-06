//
//  PostDetailView.swift
//  PostDetailView
//
//  Created by Marquis Kurt on 5/8/21.
//

import SwiftUI
import Chica

struct PostDetailView: View, InternalStateRepresentable {
    
    #if os(iOS)
    /// Determines whether the device is compact or standard
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif

    @State var state: ViewState = .initial
    
    @State var post: Status?
    
    @State var context: Context?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if let status = post {
                    postBody(for: status)
                    switch state {
                    case .initial, .loading:
                        ProgressView()
                    case .loaded:
                        contextView(from: context)
                    default:
                        EmptyView()
                    }
                } else {
                    StackedLabel(systemName: "tray", title: "Couldn't Load Post") {
                        Text("The post may not be available.")
                    }
                }
            }
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onAppear(perform: loadData)
    }
    
    internal func loadData() {
        Task.init {
            state = .loading
            try await getContext()
            state = .loaded
        }
    }
    
    private var visibilityImage: String {
        switch post?.visibility {
        case .public: return "globe"
        case .unlisted: return "eye.slash"
        case .private: return "person.2"
        default: return "star"
        }
    }
    
    private var noContextLabel: some View {
        StackedLabel(systemName: "tray", title: "timelines.context.empty") {
            Button(action: {}) {
                Text("actions.reply")
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    private func contextView(from context: Context?) -> some View {
        Group {
            if let children = context?.descendants {
                if children.isEmpty {
                    noContextLabel
                } else {
                    Group {
                        ForEach(children, id: \.self) { status in
                            PostView(post: status)
                                .background(.background)
                                .cornerRadius(6)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            } else {
                noContextLabel
            }
        }
        
    }
    
    private func getPostDate(status: Status) -> Date? {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZ"
        format.timeZone = TimeZone(abbreviation: "UTC")
        format.locale = Locale(identifier: "en_US_POSIX")
        return format.date(from: status.createdAt)
    }
    
    private func getContext() async throws {
        guard let status = post else { return }
        context = try await Chica.shared.request(.get, for: .context(id: status.id))
    }
    
    private func postBody(for status: Status) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                ProfileImage(for: .user(id: status.account.id), size: .medium)
                VStack(alignment: .leading) {
                    HStack {
                        Text(status.account.getName().emojified())
                            .font(.system(.title, design: .rounded))
                            .bold()
                        #if os(iOS)
                        if horizontalSizeClass != .compact {
                            Text("@\(status.account.acct)")
                                .font(.system(.title, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                        #else
                        Text("@\(status.account.acct)")
                            .font(.system(.title, design: .rounded))
                            .foregroundColor(.secondary)
                        #endif
                    }

                    Text(getPostDate(status: status) ?? .now, format: .dateTime)
                        .font(.system(.title2, design: .rounded))
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: visibilityImage)
                    .font(.title2)
            }
            Text(status.content.toMarkdown())
                .font(.system(.title3, design: .rounded))
            HStack {
                Button(action: {}) {
                    Label("\(status.favouritesCount)", systemImage: (status.favourited == true ? "heart.fill": "heart"))
                }
                Button(action: {}) {
                    Label("\(status.reblogsCount)", systemImage: "arrow.2.squarepath")
                }
                Button(action: {}) {
                    Label("\(status.repliesCount)", systemImage: "arrowshape.turn.up.backward")
                }
                Spacer()
                Button(action: {}) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            }
            .buttonStyle(.borderless)
            .font(.title3)
        }
        .padding()
        .padding(.horizontal)
        .background(.background)
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView()
    }
}
