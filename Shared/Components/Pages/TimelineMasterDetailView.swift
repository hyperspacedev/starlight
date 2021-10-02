//
//  TimelineView.swift
//  TimelineView
//
//  Created by Marquis Kurt on 5/8/21.
//

import SwiftUI
import Chica

/// A view that displays posts and threads in a master-detail style.
struct TimelineMasterDetailView: View {
    
    @State var scope: TimelineViewableScope
    
    /// The body of the view.
    var body: some View {
        NavigationView {
            TimelineViewable(scope: scope) { statuses in
                timeline(statuses)
            }
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
    
    private func timeline(_ statuses: [Status]?) -> some View {
        Group {
            List {
                if let stream = statuses {
                    ForEach(stream, id: \.id) { post in
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
                    Button(action: {}) {
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
        
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineMasterDetailView(scope: .home)
    }
}
