//
//  SignUpView.swift
//  Hyperspace
//
//  Created by Alex Modroño Vara on 21/2/21.
//

import SwiftUI
import Combine

#if canImport(UIKit)
import UIKit


/// Publisher to read keyboard changes.
protocol KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> { get }
}

extension KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .map { _ in true },
            
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in false }
        )
        .eraseToAnyPublisher()
    }
}
#endif

struct SignUpView: View, KeyboardReadable {

    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>

    @State private var isKeyboardVisible = false
    @State var chosenInstance: String = "twitter.com"

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            if self.presentationMode.wrappedValue.isPresented && !self.isKeyboardVisible {
                Button("\(Image(systemName: "arrow.left")) Back", action: {
                    self.presentationMode.wrappedValue.dismiss()
                })
                .foregroundColor(Color(.label))
                .font(.system(size: 17, weight: .medium, design: .rounded))
            }

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Sign Up")
                        .font(.system(size: 35, weight: .bold, design: .rounded))
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 20, weight: .medium, design: .rounded))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Text("Let's create your account so you can start interacting with the world. Select your main instance, enter an email, and a password.")
                    .foregroundColor(Color("textColor"))
                    .font(.system(size: 17, weight: .medium, design: .rounded))

            }
            

            Spacer()

            #if os(iOS)
            if !self.isKeyboardVisible {
                instanceButton
            }
            #else
            instanceButton
            #endif

            VStack(alignment: .leading, spacing: 10) {
                Text("Email address")
                    .foregroundColor(Color("textColor"))
                    .font(.system(size: 17, weight: .medium, design: .rounded))

                TextField("example@mastodon.example", text: .constant(""))
                    .textCase(.lowercase)
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("textfieldBorderColor"), lineWidth: 2)
                    )
                    .shadow(radius: 10)
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("Password")
                    .foregroundColor(Color("textColor"))
                    .font(.system(size: 17, weight: .medium, design: .rounded))

                SecureField("8 characters or more", text: .constant(""))
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("textfieldBorderColor"), lineWidth: 2)
                    )                    .shadow(radius: 10)
            }

            #if os(iOS)
            if !self.isKeyboardVisible {
                disclaimer
            }
            #else
            disclaimer
            #endif

            Spacer()

            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 5) {
                    Spacer()
                    Text("Already have an account?")
                    if self.presentationMode.wrappedValue.isPresented {
                        Button("Log In", action: {
                            self.presentationMode.wrappedValue.dismiss()
                        })
                    } else {
                        NavigationLink("Log In", destination: LoginView())
                    }
                    Spacer()
                }
                .font(.system(size: 17, weight: .medium, design: .rounded))

                Button(action: {}, label: {
                    HStack {
                        Spacer()
                        Text("Create account")
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
        .onReceive(keyboardPublisher) { newIsKeyboardVisible in
            isKeyboardVisible = newIsKeyboardVisible
        }
        .navigationBarHidden(true)
    }

    var instanceButton: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Instance")
                .foregroundColor(Color("textColor"))
                .font(.system(size: 17, weight: .medium, design: .rounded))

            NavigationLink(destination: RegisterView()) {
                HStack {
                    Image("twitter")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                    Text(chosenInstance)
                    Spacer()
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(Color(.label))
                .font(.system(size: 17, weight: .medium, design: .rounded))
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("textfieldBorderColor"), lineWidth: 2)
                )
                .shadow(radius: 10)
            }
        }
    }

    var disclaimer: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("By signing up you agree to Starlight's and \(chosenInstance)'s rules and terms of service.")
                .font(.system(size: 17, weight: .regular, design: .rounded))

            Link("Starlight Terms of Service", destination: URL(string: "https://hyperspace.marquiskurt.com")!)

            Link("\(chosenInstance) Terms of Service", destination: URL(string: "https://hyperspace.marquiskurt.com")!)
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
