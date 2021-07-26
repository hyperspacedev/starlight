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
            Text("login.register.prompt")
            loginButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .font(.system(.body, design: .rounded))
        .padding()
    }

    var header: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading) {
                Text("login.header")
                    .font(.system(.largeTitle, design: .rounded))
                    .bold()
                Text("login.info")
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
                Text(
                    String(
                        format: NSLocalizedString("login.fullname", comment: "Full username sign in"),
                        "mastodon.online"
                    )
                )
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
            Text("login.button")
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
