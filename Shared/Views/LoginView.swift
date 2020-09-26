//
//  LoginView.swift
//  Hyperspace
//
//  Created by Marquis Kurt on 9/26/20.
//

import SwiftUI

struct LoginView: View {

    @State var instanceField: String = ""

    var body: some View {
        VStack {
            Spacer()
            // TODO: Replace this image with the Starlight icon.
            Image(systemName: "person.crop.circle.fill.badge.plus")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 128)
            VStack(spacing: 8) {
            Text("Sign in to Starlight")
                .font(.title)
                .bold()
            Text(
                "Sign in with your fediverse account to view your personal feed,"
                + " chat with friends, edit your profile, and make posts on the "
                + "fediverse."
            )
            .font(.caption)
            }
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
                Button(action: {}) {
                    Text("Sign in")
                }
            }
            .padding()
            Spacer()
            Button(action: {}) {
                Text("Got an access token?")
                    .font(.footnote)
            }
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
