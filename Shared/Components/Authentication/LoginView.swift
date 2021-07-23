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
    @State private var twitterName: String = ""
    @State private var loggedIn: Bool = false

    var body: some View {
        VStack(spacing: 16.0) {
            header
            if loggedIn {
                loginTest
            }
            Spacer()
            fediverseLogin
            Text("or")
            twitterLogin
            Spacer()
            Button(action: {
                Task.init {
                    await startAuthFlow()
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
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading) {
                Text("Log In")
                    .font(.system(.largeTitle, design: .rounded))
                    .bold()
                Text(
                    "Log in to a Twitter or Mastodon account to access feeds, post content, and more."
                )
                    .foregroundColor(.gray)
            }
            Image(systemName: "star")
                .font(.largeTitle)
        }
    }
    
    var loginTest: some View {
        VStack {
            Text("Logged in!")
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

    var twitterLogin: some View {
        VStack(alignment: .leading) {
            Section("Twitter") {
                TextField("@twitter", text: $twitterName)
                    .textFieldStyle(.roundedBorder)
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

    func startAuthFlow() async {
        do {
            let _: Application? = try await Chica.shared.request(.post, for: .apps, params: [
                "client_name": "Starlight",
                "redirect_uris": "starlight://oauth",
                "scopes": "read write follow",
                "website": "https://hyperspace.marquiskurt.net"
            ])
            await Chica.OAuth.shared.startOauthFlow(for: getUserDomain())
        } catch {
            print("An unknown error occurred.")
        }

    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
