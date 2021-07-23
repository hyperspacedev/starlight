//
//  LoginView.swift
//  LoginView
//
//  Created by Marquis Kurt on 23/7/21.
//

import SwiftUI
import Chica

struct LoginView: View {

    @State private var fediverseName: String = ""

    var body: some View {
        VStack(spacing: 16.0) {
            header
            Spacer()
            fediverseLogin
            Spacer()
            Button(action: {
                Task.init {
                    await Chica.OAuth.shared.startOauthFlow(for: getUserDomain())
                }
            }) {
                Text("Log in")
            }
            .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .font(.system(.body, design: .rounded))
        .padding()
    }

    var header: some View {
        VStack(alignment: .leading) {
            Text("Log In")
                .font(.system(.largeTitle, design: .rounded))
                .bold()
            Text(
                "Log in to a Twitter or Mastodon account to access feeds, post content, and more."
            )
                .foregroundColor(.gray)
        }
    }

    var fediverseLogin: some View {
        VStack(alignment: .leading) {
            Section("Mastodon") {
                TextField("example@mastodon.online", text: $fediverseName)
                    .textFieldStyle(.roundedBorder)
                Text("Not from **mastodon.online**? Log in with your full username.")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

        }
    }
    
    func getUserDomain() -> String {
        if fediverseName.contains("@") {
            let components = fediverseName.split(separator: "@")
            return "\(components.last ?? "mastodon.online")"
        }
        return "mastodon.online"
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
