//
//  WelcomeView.swift
//  Hyperspace
//
//  Created by Alex Modroño Vara on 1/1/21.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 30) {
                VStack(alignment: .leading, spacing: 10) {

                    HStack {
                        Text("Welcome to Starlight!")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                        Spacer()
                    }

                    Text("Please log in with any of the following services before using any of our services.")
                        .foregroundColor(Color("textColor"))
                        .font(.system(size: 17, weight: .medium, design: .rounded))
                }

                Spacer()

                VStack(spacing: 20) {

                    NavigationLink(destination: LoginView(isTwitter: true)) {
                        HStack {
                            Image("twitter")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 26)
                            Text("Sign in with Twitter")
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

                    NavigationLink(destination: LoginView()) {
                        HStack {
                            Image("mastodon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                            Text("Sign in with Mastodon")
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

                    HStack {
                        Rectangle()
                            .foregroundColor(.gray)
                            .frame(height: 1)
                        Text("or")
                        Rectangle()
                            .foregroundColor(.gray)
                            .frame(height: 1)
                    }
                    .opacity(0.5)

                    NavigationLink(destination: SignUpView()) {
                        HStack {

                            Text("Create new account")

                            Spacer()
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(Color(.label))
                        .font(.system(size: 17, weight: .medium, design: .rounded))
                        .padding()
                        .overlay(
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

                }

                Spacer()

                Text("Starlight v1.0")
                    .foregroundColor(Color("textColor"))
                    .font(.system(size: 17, weight: .medium, design: .rounded))

                
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}


struct Rainbow: ViewModifier {
    let hueColors = stride(from: 0, to: 1, by: 0.1).map {
        Color(hue: $0, saturation: 1, brightness: 1)
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(GeometryReader { (proxy: GeometryProxy) in
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [.blue, .purple, .pink, .red, .orange, .yellow, .green]),
                                   startPoint: .leading,
                                   endPoint: .trailing)
                        .frame(width: proxy.size.width, height: proxy.size.height)
                }
            })
            .mask(content)
    }
}
extension View {
    func rainbow() -> some View {
        self.modifier(Rainbow())
    }
}

struct RainbowAnimation: ViewModifier {

    @State var isOn: Bool = false
    let hueColors = stride(from: 0, to: 1, by: 0.01).map {
        Color(hue: $0, saturation: 1, brightness: 1)
    }

    var duration: Double = 4
    var animation: Animation {
        Animation
            .linear(duration: duration)
            .repeatForever(autoreverses: false)
    }
    
    func body(content: Content) -> some View {

        let gradient = LinearGradient(gradient: Gradient(colors: hueColors+hueColors), startPoint: .leading, endPoint: .trailing)
        return content.overlay(GeometryReader { proxy in
            ZStack {
                gradient

                    .frame(width: 2*proxy.size.width)
                    .offset(x: self.isOn ? -proxy.size.width/2 : proxy.size.width/2)
            }
        })

            .onAppear {
                withAnimation(self.animation) {
                    self.isOn = true
                }
        }
        .mask(content)
    }
}

extension View {
    func rainbowAnimation() -> some View {
        self.modifier(RainbowAnimation())
    }
}
