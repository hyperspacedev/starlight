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
            Spacer()
            fediverseLogin
            Text("or")
            twitterLogin
            Spacer()
            Text("Don't have an account? **[Sign up &rsaquo;](starlight://register)**")
            loginButton
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
                    "Log in to a Mastodon or Twitter account to view posts from the world, create posts, follow others, and more."
                )
                    .foregroundColor(.gray)
            }
            Image(systemName: "star")
                .font(.largeTitle)
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

    var loginButton: some View {
        Button(action: {
            Task.init {
                await Chica.OAuth.shared.startOauthFlow(for: getUserDomain())
            }
        }) {
            Text("Log in")
                .bold()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.accentColor)
        .foregroundColor(.white)
        .cornerRadius(6.0)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
