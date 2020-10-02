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
    @State var showInstanceDomainHelp: Bool = false
    @State var inputValid: Bool = false

    var body: some View {
        VStack(spacing: 8) {
            // TODO: Replace image with Starlight icon
            Image(systemName: "person.crop.circle.fill.badge.plus")
                .resizable()
                .scaledToFit()
                .frame(minWidth: 48, maxWidth: 128, minHeight: 48, maxHeight: 128)
            Text("Sign in to the fediverse")
                .font(.title)
                .bold()
                .padding(8)
            HStack {
                TextField("mastodon.online", text: $instanceField)
                    .padding(10)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(4.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4.0)
                            .stroke(Color.secondary, lineWidth: 1)
                        )
                Button {
                    self.showInstanceDomainHelp.toggle()
                } label: {
                    Image(systemName: "questionmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 28)
                }
                .alert(isPresented: $showInstanceDomainHelp) {
                    Alert(
                        title: Text("Instance domain"),
                        message: Text(
                            "The instance domain is address where your account is located, such as example.com."
                        ),
                        primaryButton:
                            .default(
                                Text("OK")
                            ),
                        secondaryButton:
                            .default(Text("Learn More")) {
                                openUrl("https://docs.joinmastodon.org/user/signup/#address")
                            }
                    )
                }
                .padding(2)
            }
            HStack(spacing: 8) {
                NavigationLink(destination: authorizationView, isActive: $inputValid) {
                    Text("Next")
                }
                    .buttonStyle(DefaultButtonStyle())
                    .padding()
            }
            Spacer()
        }
        .padding()
        .navigationTitle("")
    }

    var authorizationView: some View {
        VStack {
            VStack {
                Text(
                    "We're almost there! You'll just need to grant Starlight access to your account to continue. "
                    + "Tap Authorize to continue."
                )
                Spacer()
                Button {
                    print("OK")
                } label: {
                    Text("Authorize")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.accent))
                        .cornerRadius(8.0)
                }
                NavigationLink("Got an access token?", destination: accessToken)
                    .font(.footnote)
                    .padding()
            }
            .padding()

        }
        .navigationTitle("Let's authorize")
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
                .onChange(of: instanceField) { _ in
                    self.inputValid = self.inputIsValid()
                }

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
    
    func inputIsValid() -> Bool {
        return !self.instanceField.isEmpty
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
