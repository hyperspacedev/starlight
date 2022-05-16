//
//  LoginView.swift
//  LoginView
//
//  Created by Marquis Kurt on 23/7/21.
//

import SwiftUI
import Chica
import StylableScrollView
import SafariView
import SPAlert

struct LoginView: View, KeyboardReadable {

    @StateObject var viewModel = ViewModel()
    @StateObject var manager: Chica.OAuth = Chica.OAuth.shared

    @Environment(\.colorScheme) var colorSchemes
    @Environment(\.deeplink) var deeplink

    /// An EnvironmentValue that allows us to open a URL using the appropriate system service.
    ///
    /// Can be used as follows:
    /// ```
    /// openURL(URL(string: "url")!)
    /// ```
    /// or
    /// ```
    /// openURL(url) // Where URL.type == URL
    /// ```
    @Environment(\.openURL) private var openURL

    var body: some View {
        Form {
            Section(
                header: VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                        Spacer()
                    }
                    Text("login.welcome")
                        .font(
                            .system(
                                .largeTitle,
                                design: .rounded
                            )
                        ).bold()
                        .lineLimit(10)
                        .multilineTextAlignment(.center)
                        .foregroundColor(
                            Color(.label)
                        )
                        .frame(
                            maxWidth: .infinity,
                            minHeight: 100,
                            alignment: .center
                        )
                }.padding(.top),
                footer: Text("login.info")
                    .font(.system(size: 17))
            ) { EmptyView() }
                .listRowInsets(EdgeInsets())

            Section(
                footer: Text("login.textfield.info")
            ) {
                HStack {

                    TextField(
                        "login.textfield.placeholder",
                        text: $viewModel.instanceDomain
                    )
                        .font(.system(.body, design: .rounded))

                    Text("\(Image(systemName: "globe.europe.africa.fill"))")
                        .foregroundColor(.gray)
                        .font(.system(size: 25))
                }
                .frame(height: 40)
            }

            Section {
                Button(
                    action: {
                        Task {
                            do {
                                try await Chica.OAuth.shared.startOauthFlow(
                                    for: viewModel.instanceDomain,
                                    authHandler: { url in
                                        //  Publishing changes from background threads is not allowed
                                        Task { @MainActor in
                                            viewModel.url = url
                                        }
                                    }
                                )
                            } catch {
                                let alert = SPAlertView(
                                    title: "An error ocurred",
                                    message: error.localizedDescription,
                                    preset: .error
                                )
                                alert.present()
                            }
                        }
                    },
                    label: {
                        HStack {
                            Spacer()
                            Text("login.button")
                                .bold()
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding()
                        .background(
                            Image("background")
                                .resizable()
                                .scaledToFill()
                                .edgesIgnoringSafeArea(.all)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 8)
                    }

                ).listRowInsets(EdgeInsets())
            }
        }
        .overlay(
            HStack {
                if !viewModel.keyboardVisible {
                    Text("signup.message")
                }
            }, alignment: .bottom
        )
        .onReceive(keyboardPublisher) {
            viewModel.keyboardVisible = $0
        }
        .onChange(of: self.deeplink, perform: { deeplink in
            Task {
                if case let .oauth(code) = deeplink {
                    do {
                        try await Chica.OAuth.shared.continueOauthFlow(code)
                    } catch {
                        let alert = SPAlertView(
                            title: "An error ocurred",
                            message: error.localizedDescription,
                            preset: .error
                        )
                        alert.present()
                    }
                } else if case .signUp = deeplink {
                    print("Sign up view...")
                }
            }
        })
        .fullScreenCover(
            isPresented: $viewModel.toggleSafari,
            content: {
                SafariView(url: $viewModel.url)
                    .collapsible(.constant(true))
                    .ignoresSafeArea()
            }
        )
        .navigationBarHidden(true)

    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
