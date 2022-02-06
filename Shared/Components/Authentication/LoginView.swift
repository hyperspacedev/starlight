//
//  LoginView.swift
//  LoginView
//
//  Created by Marquis Kurt on 23/7/21.
//

import SwiftUI
import Chica
import StylableScrollView

struct LoginView: View {

    @State var layer: CGRect = CGRect.init()
    @State var availableSize: CGSize = CGSize.init()

    @State var present: Bool = false
    @State var hasFinishedLoading: Bool = false

    @State var fediverseName: String = ""

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
        NavigationView {
            VStack {

                Color.clear
                    .background(
                        Image("banner")
                            .resizable()
                            .scaledToFill()
                            .frame(width: self.availableSize.width, height: self.availableSize.height / 1.5)
                            .zIndex(0.1)
                    )
                    .frame(height: self.availableSize.height / 1.5)
                    .overlay(
                        Path { path in
                            path.move(
                                to: CGPoint(
                                    x : self.layer.minX,
                                    y : self.layer.midY
                                )
                            )
                            path.addLine(
                                to : CGPoint(
                                    x: self.layer.minX,
                                    y : self.layer.maxY
                                )
                            )
                            path.addLine(
                                to : CGPoint(
                                    x: self.layer.maxX,
                                    y : self.layer.maxY
                                )
                            )
                        }
                            .fill(Color.backgroundColor)
                        .animation(.spring())
                    )
                    .background(
                        GeometryReader { proxy -> Color in

                            Task {
                                self.layer = proxy.frame(in: .global)
                            }

                            return Color.clear
                        }
                    )
                    .overlay(
                        HStack {
                            Text("login.welcome")
                                .bold()
                            .font(.largeTitle)
                            .padding()
                            Spacer()
                        }.frame(width: self.availableSize.width / 1.5),
                        alignment: .bottomLeading
                    )

                VStack(alignment: .leading) {

                    VStack(spacing: 20) {

                        HStack {

                            Text("login.thanks")
                                .bold()

                            Spacer()

                        }
                        .font(.system(size: 20))

                        HStack {

                            Text("login.info")

                            Spacer()

                        }
                        .font(.system(size: 23))
                    }

                    Spacer()

                    VStack(spacing: 10) {

                        HStack {

                            Button(
                                action: {
                                    if let url = URL(string: "starlight://register") {
                                        openURL(url)
                                    }
                                }
                            ) {
                                HStack {

                                    Spacer()

                                    Text("signup.button")

                                    Spacer()

                                }
                                .font(.system(size: 17, weight: .medium, design: .rounded))
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(
                                            LinearGradient(
                                                gradient: Gradient(
                                                    colors: [.blue, .purple, .pink, .red, .orange, .yellow, .green
                                                    ]
                                                ),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            ),
                                            lineWidth: 2
                                        )
                                        .opacity(0.6)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())

                            Menu {

                                Button("Twitter", action: {})
                                Button("Mastodon", action: {
                                    self.present.toggle()
                                })

                            } label: {
                                HStack {

                                    Spacer()

                                    Text("login.button")

                                    Spacer()

                                }
                                .font(.system(size: 17, weight: .medium, design: .rounded))
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue, lineWidth: 2)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())

                        }

                        Text("login.disclaimer")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)

                    }

                }
                .zIndex(1)
                .background(
                    Color.backgroundColor
                )
                .padding([.horizontal, .bottom])

                Spacer()

            }
            .navigationBarHidden(true)
            .ignoresSafeArea()
            .background(
                GeometryReader { proxy -> Color in

                    Task {
                        self.availableSize = proxy.frame(in: .global).size
                    }

                    return Color.clear
                }
            )
            .sheet(isPresented: $present) {
                HalfSheet {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Button(
                                action: {
                                    self.present.toggle()
                                },
                                label: {
                                    Text("\(Image(systemName: "xmark"))")
                                        .bold()
                                        .foregroundColor(.secondary)
                                        .padding(10)
                                        .background(
                                            Circle()
                                                .foregroundColor(
                                                    Color(.systemGray6)
                                                )
                                        )
                                }
                            )

                            Spacer()

                        }
                        .overlay(
                            VStack(spacing: 10) {
                                Text("login.picker.title")
                                    .foregroundColor(.gray)
                                    .font(
                                        .system(
                                            size: 17,
                                            weight: .bold,
                                            design: .monospaced
                                        )
                                    )
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundColor(Color(.systemGray6))
                                    .frame(width: 150, height: 3)
                            },
                            alignment: .center
                        )

                        TextField(
                            "login.picker.textfield.placeholder",
                            text: self.$fediverseName
                        )
                            .font(.system(size: 17, weight: .bold, design: .default))
                            .foregroundColor(.gray)
                            .padding()
                            .background(
                                Color(.systemGray6)
                                    .cornerRadius(10)
                            )
                        Text("login.picker.info")
                            .font(.system(size: 16))
                            .opacity(0.8)
                        Spacer()
                    }
                    .overlay(
                        Button(
                            action: {
                                Task.init {
                                    print(self.manager.authState)
                                    await Chica.OAuth.shared.startOauthFlow(for: self.fediverseName)
                                }
                            },
                            label: {
                                HStack {
                                    Spacer()

                                    if self.manager.authState == .signinInProgress {
                                        ProgressView(value: 1)
                                            .progressViewStyle(CircularProgressViewStyle())
                                    } else  {
                                        Text("login.button")
                                            .foregroundColor(.white)
                                            .bold()
                                    }

                                    Spacer()
                                }
                                .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(.blue)
                                    )
                            })
                            .disabled(self.manager.authState == .signinInProgress),
                        alignment: .bottom
                    )
                    .padding()
                }
            }
            .onChange(of: self.manager.authState, perform: {
                switch $0 {
                case .authenthicated(_):
                    self.present.toggle()
                default:
                    break
                }
            })
            .onChange(of: self.deeplink, perform: { deeplink in
                Task.init {
                    if case let .oauth(code) = deeplink {
                        await Chica.OAuth.shared.continueOauthFlow(code)
                    }
                }
            })
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

class HalfSheetController<Content>: UIHostingController<Content> where Content : View {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let presentation = sheetPresentationController {
            // configure at will
            presentation.detents = [.medium()]
            presentation.preferredCornerRadius = 30
        }
    }
}

struct HalfSheet<Content>: UIViewControllerRepresentable where Content : View {

    private let content: Content
    
    @inlinable init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    func makeUIViewController(context: Self.Context) -> HalfSheetController<Content>{
        return HalfSheetController(rootView: content)
    }
    
    func updateUIViewController(_: HalfSheetController<Content>, context: Self.Context) {

    }
}

//
//struct LoginView: View {
//
//    @State private var fediverseName: String = ""
//    @State private var twitterName: String = ""
//    @State private var loggedIn: Bool = false
//
//    var body: some View {
//        VStack(spacing: 16.0) {
//            header
//            Spacer()
//            fediverseLogin
//            Text("or")
//            twitterLogin
//            Spacer()
//            Text("login.register.prompt")
//            loginButton
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .font(.system(.body, design: .rounded))
//        .padding()
//    }
//
//    var header: some View {
//        HStack(alignment: .firstTextBaseline) {
//            VStack(alignment: .leading) {
//                Text("login.header")
//                    .font(.system(.largeTitle, design: .rounded))
//                    .bold()
//                Text("login.info")
//                    .foregroundColor(.gray)
//            }
//            Image(systemName: "star")
//                .font(.largeTitle)
//        }
//    }
//
//    var fediverseLogin: some View {
//        VStack(alignment: .leading) {
//            Section("Mastodon") {
//                TextField("example@mastodon.online", text: $fediverseName)
//                    .textFieldStyle(.paddedRoundedBorder)
//                Text(
//                    String(
//                        format: NSLocalizedString("login.fullname", comment: "Full username sign in"),
//                        "mastodon.online"
//                    )
//                )
//                    .font(.caption)
//                    .foregroundColor(.gray)
//            }
//
//        }
//    }
//
//    var twitterLogin: some View {
//        VStack(alignment: .leading) {
//            Section("Twitter") {
//                TextField("@twitter", text: $twitterName)
//                    .textFieldStyle(.paddedRoundedBorder)
//            }
//
//        }
//    }
//
//    func getUserDomain() -> String {
//        if fediverseName.contains("@") {
//            let components = fediverseName.split(separator: "@")
//            return "\(components.last ?? "mastodon.online")"
//        }
//        return "mastodon.online"
//    }
//
//    var loginButton: some View {
//        Button(action: {
//            Task.init {
//                await Chica.OAuth.shared.startOauthFlow(for: getUserDomain())
//            }
//        }) {
//            Text("login.button")
//                .bold()
//        }
//        .buttonStyle(.plain)
//        .padding()
//        .frame(maxWidth: .infinity)
//        .background(Color.accentColor)
//        .foregroundColor(.white)
//        .cornerRadius(6.0)
//    }
//}
//
//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
