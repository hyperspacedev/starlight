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
    
    private var header: HeaderContent?
    
    private let timer = Timer.publish(every: 15, on: .current, in: .common).autoconnect()
    
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
        
    private var stream: some View {
        Group {
            if let postStream = posts {
                if postStream.isEmpty {
                    emptyView
                } else {
                    ForEach(postStream, id: \.self) { status in
                        Text(status.content.toMarkdown())
                            .padding()
                            .border(.selection, width: 1)
                    }
                }

            } else {
                Text("misc.placeholder")
                    .font(.system(.title, design: .rounded))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
            try await fetchPostsFromTimeline()
            lastUpdate = Date.now
        }
    }

    private func fetchPostsFromTimeline() async throws {
        // TODO: Implement the proper timeline networking requests here.
        switch timeline {
        case .home:
            posts = []
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
