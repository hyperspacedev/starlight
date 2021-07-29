//
//  TimelineView.swift
//  TimelineView
//
//  Created by Marquis Kurt on 26/7/21.
//

import SwiftUI
import Chica

/// A view that displays a timeline of posts.
public struct TimelineView<HeaderContent: View> : View {
    
    enum Timeline {
        case home
        case local
        case `public`
    }
    
    init(_ timelineScope: TimelineView.Timeline, @ViewBuilder header: () -> HeaderContent) {
        self.header = header()
        self.timeline = timelineScope
    }
    
    var timeline: Timeline
    
    @State private var posts: [Status]? = []
    @State private var lastUpdate: Date = Date.now
    @State private var lastUpdateString = ""
    
    @State private var state: ViewState = .initial
    
    private var header: HeaderContent?
    
    private let timer = Timer.publish(every: 15, on: .current, in: .common).autoconnect()
    
    private let gridLayout: [GridItem] = [.init(.adaptive(minimum: 300, maximum: .infinity), spacing: 4, alignment: .top)]
    
    private var title: String {
        switch timeline {
        case .home:
            return NSLocalizedString("tabs.home", comment: "Home")
        case .local:
            return NSLocalizedString("tabs.network", comment: "Network")
        case .public:
            return "In the Fediverse"
        }
    }
        
    public var body: some View {
        Group {
            ScrollView {
                VStack {
                    #if os(iOS)
                    if self.header != nil { header }
                    #endif
                    stream
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear(perform: loadData)
        .refreshable(action: loadData)
        .navigationTitle(title)
        #if os(macOS)
        .navigationSubtitle(
            lastUpdateString == ""
            ? NSLocalizedString("timelines.updatediff.started", comment: "Just updated")
            : String(
                format: NSLocalizedString("timelines.updatediff", comment: "Last updated string"),
                lastUpdateString
            )
        )
        #endif
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onReceive(timer) { _ in
            updateRefreshableString()
        }
    }
    
    private var emptyView: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .font(.largeTitle)
            Text("timelines.empty")
                .font(.system(.title, design: .rounded))
            Button(action: refresh) {
                Text("actions.reload")
            }
            .buttonStyle(.borderedProminent)
            .foregroundColor(.white)
        }
        .foregroundColor(.secondary)
        .padding(16)
    }
    
    @ViewBuilder private func postGrid(_ stream: [Status]) -> some View {
        Group {
            if stream.isEmpty {
                emptyView
            } else {
                LazyVGrid(columns: gridLayout) {
                    ForEach(stream, id: \.self) { status in PostView(post: status) }
                }.padding()
            }
        }
        
    }
        
    private var stream: some View {
        Group {
            switch state {
            case .initial, .loading:
                ProgressView()
                    .padding()
            case .loaded:
                if let statuses = posts {
                    postGrid(statuses)
                }
            case .errored(_):
                Text("misc.placeholder")
                    .font(.system(.title, design: .rounded))
            }
        }
    }
    
    /// Refresh the data for this timeline.
    ///
    /// This can be called by parent views to update the view in its refreshable code.
    func refresh() {
        print("Refresh task called.")
        loadData()
    }
    
    private func loadData() {
        Task.init {
            state = .loading
            do {
                try await fetchPostsFromTimeline()
                state = .loaded
            } catch {
                state = .errored(reason: "Unknown error")
            }
            lastUpdate = Date.now
        }
    }

    private func fetchPostsFromTimeline() async throws {
        // TODO: Implement the proper timeline networking requests here.
        switch timeline {
        case .home:
            posts = []
            // posts = try await Chica.shared.request(.get, for: .accountStatuses(id: "308724"))
        case .local:
            posts = []
        case .public:
            posts = []
        }
    }
    
    private func updateRefreshableString() {
        let formatter = DateComponentsFormatter()
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .dropAll
        lastUpdateString = (formatter.string(from: Date.now.timeIntervalSince(lastUpdate)) ?? "")
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView(.home){ }
    }
}
