//
//  ManagedAccountView.swift
//  Hyperspace
//
//  Created by Marquis Kurt on 10/1/20.
//

import SwiftUI

struct ManagedAccountView: View {
    var body: some View {
        VStack {
            Image("starlight-beta-icon")
                .resizable()
                .frame(width: 50, height: 50)

            Spacer()

            Text("Login\nto your account")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)

            VStack {

                TextField("Email", text: .constant(""))
                    .padding()
                    .background(
                        BlurView(style: .regular)
                            .opacity(0.7)
                            .cornerRadius(5)
                )

                SecureField("Password", text: .constant(""))
                    .padding()
                    .background(
                        BlurView(style: .regular)
                            .opacity(0.7)
                            .cornerRadius(5)
                )

                Button(action: {}, label: {
                    HStack {
                        Spacer()
                        Text("Forgot your password?")
                    }
                })
                .buttonStyle(PlainButtonStyle())
                .opacity(0.7)

            }

            Button(action: {}, label: {
                HStack {
                    Spacer()
                    Text("Log In")
                        .bold()
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding()
                .background(Color.white.cornerRadius(5))
            })
            .padding(.vertical)

            HStack {
                Text("Don't have an account?")
                    .opacity(0.8)

                NavigationLink("Sign Up", destination: RegisterView())
                    .foregroundColor(.white)
                    .font(.headline)
            }

            Spacer()

            Text("or log in with")

            HStack {

                Button(action: {}, label: {
                    Spacer()
                    Text("Twitter")
                    Spacer()
                })
                    .buttonStyle(PlainButtonStyle())

                Rectangle()
                    .foregroundColor(.gray)
                    .frame(width: 0.7, height: 50)

                Button(action: {}, label: {
                    Spacer()
                    Text("Apple")
                    Spacer()
                })
                    .buttonStyle(PlainButtonStyle())

            }
                .font(.headline)
                .background(
                    BlurView(style: .light)
                        .opacity(0.7)
                        .cornerRadius(10)
                )
        }
        .padding()
        .colorScheme(.dark)
        .frame(maxHeight: .infinity)
        .navigationTitle("")
        .background(
            Image("space2")
                .resizable()
                .scaledToFill()
                .overlay(
                    Color.black
                        .opacity(0.5)
                )
                .edgesIgnoringSafeArea(.all)
        )
    }
}

struct ManagedAccountView_Previews: PreviewProvider {
    static var previews: some View {
        ManagedAccountView()
    }
}

struct BlurView: UIViewRepresentable {
    typealias UIViewType = UIVisualEffectView
    
    let style: UIBlurEffect.Style
    
    init(style: UIBlurEffect.Style = .systemMaterial) {
        self.style = style
    }
    
    func makeUIView(context: Self.Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: self.style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Self.Context) {
        uiView.effect = UIBlurEffect(style: self.style)
    }
}
