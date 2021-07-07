//
//  LoginView.swift
//  Hyperspace
//
//  Created by Marquis Kurt on 9/26/20.
//

import SwiftUI

struct LoginView: View {

    @State var email: String = ""
    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>
    @State var isTwitter: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {

            VStack(alignment: .leading, spacing: 10) {

                if self.presentationMode.wrappedValue.isPresented {
                    Button("\(Image(systemName: "arrow.left")) Back", action: {
                        self.presentationMode.wrappedValue.dismiss()
                    })
                    .foregroundColor(Color(.label))
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                }

                Text("Login")
                    .font(.system(size: 35, weight: .bold, design: .rounded))

                Text("Enter the email associated with your account and we'll redirect you to the endpoints for authorization.")
                    .foregroundColor(Color("textColor"))
                    .font(.system(size: 17, weight: .medium, design: .rounded))
            }

            Spacer()

            if self.isTwitter {
                VStack(alignment: .leading, spacing: 10) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("TWITTER")
                            .font(.system(size: 17, weight: .medium, design: .rounded))

                        Divider()
                    }
                    
                    Text("Email address")
                        .foregroundColor(Color("textColor"))
                        .font(.system(size: 17, weight: .medium, design: .rounded))

                    TextField("twitter@example.com", text: self.$email)
                        .textCase(.lowercase)
                        .font(.system(size: 17, weight: .medium, design: .rounded))
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("textfieldBorderColor"), lineWidth: 2)
                        )
                        .shadow(radius: 10)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Password")
                            .foregroundColor(Color("textColor"))
                            .font(.system(size: 17, weight: .medium, design: .rounded))

                        SecureField("Password", text: .constant(""))
                            .font(.system(size: 17, weight: .medium, design: .rounded))
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("textfieldBorderColor"), lineWidth: 2)
                            )                    .shadow(radius: 10)
                    }
                }
            } else {
                VStack(alignment: .leading, spacing: 10) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("MASTODON")
                            .font(.system(size: 17, weight: .medium, design: .rounded))

                        Divider()
                    }
                    
                    Text("Username")
                        .foregroundColor(Color("textColor"))
                        .font(.system(size: 17, weight: .medium, design: .rounded))

                    TextField("example@mastodon.example", text: self.$email)
                        .textCase(.lowercase)
                        .font(.system(size: 17, weight: .medium, design: .rounded))
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("textfieldBorderColor"), lineWidth: 2)
                        )
                        .shadow(radius: 10)

                    HStack {
                        Text("Not from ") + Text("mastodon.online").bold() + Text("? Log in using your full username.")
                    }
                    .font(.system(size: 17, weight: .regular, design: .rounded))
                }
            }

            Spacer()

            VStack(alignment: .leading, spacing: 10) {

                HStack(spacing: 5) {
                    Spacer()
                    Text("Don't have an account?")
                    NavigationLink("Sign Up", destination: SignUpView())
                    Spacer()
                }
                .font(.system(size: 17, weight: .medium, design: .rounded))

                Button(action: {
                    
                }, label: {
                    HStack {
                        Spacer()
                        Text("Log In")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        Spacer()
                    }
                })
                    .padding()
                    .background(
                        Color.purple
                            .cornerRadius(10)
                    )


            }
        }
        .padding()
        .navigationBarHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
