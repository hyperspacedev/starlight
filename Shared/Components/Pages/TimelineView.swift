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
    
    init(_ timelineScope: TimelineScope, with networkScope: TimelineNetworkScope = .none, @ViewBuilder header: () -> HeaderContent) {
        self.header = header()
        self.timeline = timelineScope
        self.networkScope = networkScope
    }
    
    var timeline: TimelineScope
    var networkScope: TimelineNetworkScope
    
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
        case .network where self.networkScope == .local:
            return NSLocalizedString("network.local", comment: "Network")
        case .network where self.networkScope == .federated:
            return NSLocalizedString("network.federated", comment: "Network")
        case .tag(let tag):
            return "#\(tag)"
        default:
            return ""
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
        .onAppear { loadData(with: networkScope) }
        .refreshable { loadData(with: networkScope) }
        .onChange(of: networkScope) { value in
            loadData(with: value)
        }
        #if os(macOS)
        .navigationTitle(title)
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
    
    private func loadData(with scope: TimelineNetworkScope = .none) {
        Task.init {
            state = .loading
            do {
                try await fetchPostsFromTimeline(with: scope)
                state = .loaded
            } catch {
                state = .errored(reason: "Unknown error")
            }
            lastUpdate = Date.now
        }
    }

    private func fetchPostsFromTimeline(with scope: TimelineNetworkScope) async throws {
        do {
            switch timeline {
            case .network where scope == .federated:
                posts = try await Chica.shared.request(.get, for: .timeline(scope: .network), params: ["local": "false"])
            case .network where scope == .local:
                posts = try await Chica.shared.request(.get, for: .timeline(scope: .network), params: ["local": "true"])
            case .tag(_) where scope == .local:
                posts = try await Chica.shared.request(.get, for: .timeline(scope: timeline), params: ["local": "true"])
            default:
                print("OTHER")
                posts = try await Chica().request(.get, for: .timeline(scope: timeline))
            }
        } catch FetchError.message(let reason, let data) {
            print(reason)
            print(data.base64EncodedString())
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
