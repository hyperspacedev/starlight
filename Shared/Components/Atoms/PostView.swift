//
//  PostView.swift
//  PostView
//
//  Created by Marquis Kurt on 28/7/21.
//

import SwiftUI
import Chica

struct PostView: View {
    
    var post: Status? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            if let status = post {
                Text(RelativeDateTimeFormatter().localizedString(for: getPostDate(status: status) ?? .now, relativeTo: .now))
                    .foregroundColor(.secondary)
                    .font(.caption)
                VStack(alignment: .leading) {
                    Text(status.content.toMarkdown())
                }
                .frame(maxWidth: .infinity)
                Spacer()
            }
            HStack(spacing: 8) {
                Button(action: {}) {
                    Image(systemName: "heart")
                }
                Button(action: {}) {
                    Image(systemName: "arrowshape.turn.up.left")
                }
                Button(action: {}) {
                    Image(systemName: "arrow.2.squarepath")
                }
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                }
                Spacer()
                Image(systemName: visibilityImage)
                    .foregroundColor(.secondary)
            }
            .font(.title2)
            .buttonStyle(.borderless)
        }
        .padding()
        .background(.background)
        .cornerRadius(6)
    }
    
    private func getPostDate(status: Status) -> Date? {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZ"
        format.timeZone = TimeZone(abbreviation: "UTC")
        format.locale = Locale(identifier: "en_US_POSIX")
        return format.date(from: status.createdAt)
    }
    
    private var visibilityImage: String {
        switch post?.visibility {
        case .public: return "globe"
        case .unlisted: return "eye.slash"
        case .private: return "person.2"
        default: return "star"
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
