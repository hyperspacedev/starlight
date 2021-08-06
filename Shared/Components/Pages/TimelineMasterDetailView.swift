//
//  TimelineView.swift
//  TimelineView
//
//  Created by Marquis Kurt on 5/8/21.
//

import SwiftUI
import Chica

/// A view that displays posts and threads in a master-detail style.
struct TimelineMasterDetailView: View, InternalStateRepresentable {
    
    /// The timeline to fetch data from.
    var timeline: TimelineScope
    
    /// Whether to restrict the timeline fetch to only local data.
    ///
    /// Defaults to `false.`
    var localOnly: Bool = false
    
    /// The internal state of the view.
    @State var state: ViewState = .initial
    
    /// The list of posts for this view.
    @State private var statuses: [Status]? = []
    
    /// When the timeline was last fetched.
    @State private var lastUpdate: Date = .now
    
    /// An internal timer to update the state of the view periodically.
    private let timer = Timer.publish(every: 30, on: .current, in: .common).autoconnect()
    
    /// The body of the view.
    var body: some View {
        NavigationView {
            switch state {
            case .initial, .loading:
                List {
                    ForEach(0..<10) { _ in dummyPost }
                }
                #if os(macOS)
                .listStyle(.bordered(alternatesRowBackgrounds: true))
                .frame(minWidth: 400)
                #endif
                .redacted(reason: .placeholder)
                StackedLabel(systemName: "newspaper", title: "timelines.detail.title") {
                    Text("timelines.detail.subtitle")
                }
            case .loaded, .updated:
                loadedTimeline
            case let .errored(reason):
                StackedLabel(systemName: "exclamationmark.triangle", title: "timelines.errored") {
                    VStack {
                        Text(reason)
                        Button(action: loadData) {
                            Text("actions.reload")
                        }
                    }
                }
            }
            
        }
        .onAppear(perform: loadData)
        .refreshable(action: loadData)
        .onChange(of: localOnly) { newValue in loadData(with: newValue) }
        .navigationTitle(title())
        #if os(macOS)
        .navigationSubtitle(
            Text(lastUpdate, format: .relative(presentation: .named))
        )
        #else
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onReceive(timer) { _ in
            state = .loading
            state = .updated
        }
        .toolbar {
            #if os(macOS)
            ToolbarItem {
                Button(action: loadData) {
                    Label("actions.reload", systemImage: "arrow.clockwise")
                }
                .keyboardShortcut(.init("r"), modifiers: [.command])
                .help("actions.reload")
            }
            #endif
        }
    }
    
    /// A dummy placeholder post for loading purposes.
    private var dummyPost: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "person")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 32)
                VStack(alignment: .leading) {
                    Text("Hey")
                        .bold()
                    Text("Hi")
                        .font(.caption)
                }
            }
            Text("This was a triumph. I'm making a note here: huge success. It's hard to overstate my satisfaction.")
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
    
    /// The fully loaded timeline content.
    private var loadedTimeline: some View {
        Group {
            List {
                if let stream = statuses {
                    ForEach(stream, id: \.self) { post in
                        NavigationLink(destination: PostDetailView(post: post)) {
                            PostView(post: post, truncate: true)
                        }
                    }
                }
            }
            #if os(macOS)
            .listStyle(.bordered(alternatesRowBackgrounds: true))
            .frame(minWidth: 400)
            #else
            .listStyle(.insetGrouped)
            #endif
            
            if statuses?.isEmpty == true {
                StackedLabel(systemName: "tray", title: "timelines.empty") {
                    Button(action: loadData) {
                        Text("actions.reload")
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else {
                StackedLabel(systemName: "newspaper", title: "timelines.detail.title") {
                    Text("timelines.detail.subtitle")
                }
            }
        }
    }
    
    /// Load the data into the view and render it.
    internal func loadData() {
        Task.init {
            state = .loading
            statuses = try await Chica.shared.request(
                .get,
                for: .timeline(scope: timeline),
                params: localOnly ? ["local": "true"] : nil
            )
            lastUpdate = .now
            state = .loaded
        }
    }
    
    /// Load the data into the view with respect to a local context and view it.
    /// - Parameter localRestrict: Whether to restrict the fetching to local posts only.
    func loadData(with localRestrict: Bool) {
        Task.init {
            state = .loading
            do {
                statuses = try await Chica.shared.request(
                    .get,
                    for: .timeline(scope: timeline),
                    params: localRestrict ? ["local": "true"] : nil
                )
                state = .loaded
            } catch FetchError.message(let reason, _){
                state = .errored(reason: reason)
            }

        }
    }
    
    /// Returns a suitable title for the NavigationView.
    private func title() -> LocalizedStringKey {
        switch timeline {
        case .network:
            return "tabs.network"
        case .home:
            return "tabs.home"
        case .messages:
            return "tabs.messages"
        case .list(let id):
            return "\(id)"
        case .tag(let tag):
            return "#\(tag)"
        }
    }
    
    /// Returns a suitable subtitle for the NavigationView.
    private func subtitle() -> String {
        let formatter = DateComponentsFormatter()
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .dropAll
        return formatter.string(from: Date.now.timeIntervalSince(lastUpdate)) ?? ""
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineMasterDetailView(timeline: .home)
    }
}
