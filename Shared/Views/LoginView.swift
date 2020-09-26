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
        NavigationView {
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
                NavigationLink("Got an access token?", destination: accessToken)
                    .font(.footnote)
            }
            .padding()
        }
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
