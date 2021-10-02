//
//  TimelineScrollViewCompatible.swift
//  TimelineScrollViewCompatible
//
//  Created by Marquis Kurt on 5/8/21.
//

import SwiftUI
import Chica

/// A view that displays posts and threads in a master-detail style.
struct TimelineScrollViewCompatible: View {
    
    @State var scope: TimelineViewableScope
    
    var body: some View {
        TimelineViewable(scope: scope) { statuses in
            timeline(statuses)
        }
    }
    
    private func timeline(_ statuses: [Status]?) -> some View {
        Group {
            if let stream = statuses {
                ForEach(stream, id: \.id) { post in
                    NavigationLink(destination: PostDetailView(post: post)) {
                        PostView(post: post, truncate: true)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
            if statuses?.isEmpty == true {
                StackedLabel(systemName: "tray", title: "timelines.empty") {
                    Button(action: {}) {
                        Text("actions.reload")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

struct TimelineScrollViewCompatible_Previews: PreviewProvider {
    static var previews: some View {
        TimelineMasterDetailView(scope: .home)
    }
}
