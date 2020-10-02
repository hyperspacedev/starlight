//
//  ManagedAccountView.swift
//  Hyperspace
//
//  Created by Marquis Kurt on 10/1/20.
//

import SwiftUI

struct ManagedAccountView: View {
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    // TODO: Replace image with Starlight icon
                    Image(systemName: "person.crop.circle.fill.badge.plus")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 128)
                    VStack(spacing: 8) {
                    Text("Connect to Starlight")
                        .font(.title)
                        .bold()
                    Text(
                        "Sign in with your fediverse account to view your personal feed,"
                        + " chat with friends, edit your profile, and make posts on the "
                        + "fediverse."
                    )
                        .font(.caption)
                }
                    .padding(8)
                    VStack(spacing: 16) {
                        NavigationLink(destination: LoginView()) {
                                Text("Sign In")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color(.accent))
                                    .cornerRadius(8.0)
                            }
                        NavigationLink(destination: RegisterView()) {
                            Text("Sign Up")
                                .foregroundColor(.primary)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(.tertiarySystemFill))
                                .cornerRadius(8.0)
                        }
                    }
                }
                .padding()
            }
            .colorScheme(.dark)
            .frame(maxHeight: .infinity)
            .navigationBarHidden(true)
            .navigationTitle("")
            .background(
                Image("spaceBg")
                    .resizable()
                    .scaledToFill()
            )
        }
    }
}

struct ManagedAccountView_Previews: PreviewProvider {
    static var previews: some View {
        ManagedAccountView()
    }
}
