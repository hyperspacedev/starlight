//
//  TimelineViewable.swift
//  Starlight
//
//  Created by Marquis Kurt on 2/10/21.
//

import SwiftUI
import Chica

struct TimelineViewable<Content: View>: View, InternalStateRepresentable {
    
    // MARK: - Fields
    
    var scope: TimelineViewableScope
    var viewLoaded: ([Status]?) -> Content
    
    @State var state: ViewState = .initial
    @State private var statuses: [Status]? = []
    @State private var lastUpdate: Date = .now
    
    private let timer = Timer.publish(every: 30, on: .current, in: .common).autoconnect()
    
    init(scope: TimelineViewableScope, @ViewBuilder content: @escaping ([Status]?) -> Content) {
        self.scope = scope
        self.viewLoaded = content
    }
    
    // MARK: - Views
    
    var body: some View {
        Group {
            switch state {
            case .initial, .loading:
                ForEach(0..<10) { _ in
                    DummyPost()
                        .redacted(reason: .placeholder)
                }
            case .loaded, .updated:
                viewLoaded(statuses)
            case .errored(let reason):
                viewErrored(reason: reason)
            }
        }
        .onAppear(perform: loadData)
        .refreshable { loadData() }
        .navigationTitle(title())
        .onReceive(timer) { _ in
            state = .loading
            state = .updated
        }
        #if os(macOS)
        .navigationSubtitle(
            Text(lastUpdate, format: .relative(presentation: .named))
        )
        .toolbar {
            ToolbarItem {
                Button(action: loadData) {
                    Label("actions.reload", systemImage: "arrow.clockwise")
                }
                .keyboardShortcut(.init("r"), modifiers: [.command])
                .help("actions.reload")
            }
        }
        #else
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
    
    private func title() -> LocalizedStringKey {
        switch scope {
        case .home:
            return "tabs.home"
        case .messages:
            return "tabs.network"
        case .empty:
            return "misc.placeholder"
        case .network(_):
            return "tabs.network"
        case .list(let id):
            return "\(id)"
        case .tag(let id):
            return "#\(id)"
        case .profile(_):
            return "tabs.profile"
        }
    }
    
    private func subtitle() -> String {
        let formatter = DateComponentsFormatter()
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .dropAll
        return formatter.string(from: Date.now.timeIntervalSince(lastUpdate)) ?? ""
    }
    
    private func viewErrored(reason: String) -> some View {
        StackedLabel(systemName: "exclamationmark.triangle", title: "timelines.errored") {
            VStack {
                Text(reason)
                Button(action: loadData) {
                    Text("actions.reload")
                }
            }
        }
    }
    
    // MARK: - State Management
    
    internal func loadData() {
        if (statuses?.isEmpty != true) { return }
        Task.init {
            state = .loading
            do {
                try await fetchTimelineData()
                state = .loaded
            } catch FetchError.message(let reason, _) {
                state = .errored(reason: reason)
            }
            lastUpdate = .now
        }
    }
    
    func fetchTimelineData() async throws {
        switch scope {
        case .home:
            statuses = try await Chica.shared.request(
                .get,
                for: .timeline(scope: .home)
            )
        case .messages:
            statuses = try await Chica.shared.request(
                .get,
                for: .timeline(scope: .messages)
            )
        case .empty:
            statuses = []
        case .network(let localOnly):
            statuses = try await Chica.shared.request(
                .get,
                for: .timeline(scope: .network),
                body: localOnly ? ["local": "true"] : nil
            )
        case .list(let id):
            statuses = try await Chica.shared.request(
                .get,
                for: .timeline(scope: .list(id: id))
            )
        case .tag(let id):
            statuses = try await Chica.shared.request(
                .get,
                for: .timeline(scope: .tag(tag: id))
            )
        case .profile(let id):
            statuses = try await Chica.shared.request(
                .get,
                for: .accountStatuses(id: id)
            )
        }
    }
}

struct TimelineViewable_Previews: PreviewProvider {
    static var previews: some View {
        TimelineViewable(scope: .empty) { statuses in
            EmptyView()
        }
    }
}
