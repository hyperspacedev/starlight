//
//  LoginView.swift
//  Hyperspace
//
//  Created by Marquis Kurt on 9/26/20.
//

import SwiftUI

struct LoginView: View {

    @State var instanceField: String = ""
    @State var accessTokenField: String = ""

    var body: some View {
        VStack {
            VStack(spacing: 8) {
                HStack {
                    TextField("mastodon.online", text: $instanceField)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    // TODO: Hook this up to some help dialog to explain what the
                    // instance domain is.
                    Button(action: {}) {
                        Image(systemName: "questionmark.circle")
                    }
                }
                HStack(spacing: 8) {
                    Button(action: {}) {
                        Text("Sign in")
                    }
                        .buttonStyle(DefaultButtonStyle())
                }

            }
            .padding()
            Spacer()
            NavigationLink("Got an access token?", destination: accessToken)
                .font(.footnote)
        }
        .padding()
    }

    var accessToken: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(
                    "If you have already made an access token for this app or cannot log in"
                    + " normally, you can add it here. Starlight will take care of the rest."
                )
            }
            TextField("Access token", text: $accessTokenField)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {}) {
                Text("Sign in with access token")
            }
            Spacer()
            Button(action: {}) {
                Text("Create an access token")
                    .font(.footnote)
            }
        }
        .padding()
        .navigationTitle("Use an access token")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
