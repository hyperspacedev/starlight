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
    
    var truncate: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let status = post {
                authorHeader(of: status)
                Text(status.content.toMarkdown())
                    .lineLimit(truncate ? 3 : .max)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    private func authorHeader(of status: Status) -> some View {
        HStack {
            ProfileImage(for: .user(id: status.account.id), size: .small)
            VStack(alignment: .leading) {
                Text(status.account.getName().emojified())
                    .bold()
                Text(RelativeDateTimeFormatter().localizedString(for: getPostDate(status: status) ?? .now, relativeTo: .now))
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            Spacer()
            Image(systemName: visibilityImage)
                .foregroundColor(.secondary)
        }
        .font(.system(.body, design: .rounded))
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
