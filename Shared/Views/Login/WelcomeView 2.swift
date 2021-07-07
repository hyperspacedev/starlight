//
//  WelcomeView.swift
//  Hyperspace
//
//  Created by Alex Modroño Vara on 1/1/21.
//

import SwiftUI

struct WelcomeView: View {

    @State var index: Int = 0
    @State private var offset: CGFloat = 0
    @State private var isUserSwiping: Bool = false

    var body: some View {
        NavigationView {
            VStack {

                VStack {

                    Image("starlight-beta-icon")
                        .resizable()
                        .frame(width: 50, height: 50)

                    VStack(spacing: 10) {

                        Text("Welcome to Starlight")
                            .bold()
                            .font(.title3)

                        Text("The best Twitter and Mastodon client in the entire fediverse.")
                            .multilineTextAlignment(.center)
                            .opacity(0.7)

                    }

                }

                Spacer()

                VStack(spacing: 20) {

                    benefits

                    HStack(spacing: 10) {

                        Circle()
                            .foregroundColor(.white)
                            .opacity(self.index == 0 ? 1 : 0.2)
                            .frame(width: 10, height: 10)

                        Circle()
                            .foregroundColor(.white)
                            .opacity(self.index == 1 ? 1 : 0.2)
                            .frame(width: 10, height: 10)

                        Circle()
                            .foregroundColor(.white)
                            .opacity(self.index == 2 ? 1 : 0.2)
                            .frame(width: 10, height: 10)

                    }

                }
                .padding(40)

                HStack {
                    NavigationLink(destination: ManagedAccountView(), label: {
                        Spacer()
                        Text("Log In")
                            .font(.title3)
                            .bold()
                        Spacer()
                    })
                        .padding()
                        .buttonStyle(PlainButtonStyle())
                        .background(
                            BlurView(style: .light)
                                .opacity(0.7)
                                .cornerRadius(10)
                        )

                    NavigationLink(destination: RegisterView(), label: {
                        Spacer()
                        Text("Sign Up")
                            .font(.title3)
                            .bold()
                        Spacer()
                    })
                        .padding()
                        .buttonStyle(PlainButtonStyle())
                        .background(
                            BlurView(style: .light)
                                .opacity(0.7)
                                .cornerRadius(10)
                        )

                }

            }
            .padding()
            .colorScheme(.dark)
            .frame(maxHeight: .infinity)
            .navigationBarHidden(true)
            .navigationTitle("")
            .background(
                Image("space3")
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

    var benefits: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 0) {
                    ForEach(0 ..< 3) { currentPage in

                        VStack(spacing: 10) {

                            Spacer()

                            if currentPage == 0 {
                                Text("The best from both worlds")
                                    .bold()
                                    .font(.title2)
                                    .multilineTextAlignment(.center)

                                Text("Have both your Twitter and Mastodon accounts in the same app, connecting the best from both worlds.")
                                    .multilineTextAlignment(.center)
                            } else if currentPage == 1 {
                                Text("Multiplatform")
                                    .bold()
                                    .font(.title2)
                                    .multilineTextAlignment(.center)

                                Text("Starlight is available for macOS, iPadOS, and iOS, so that you can enjoy using these social networks inall devices.")
                                    .multilineTextAlignment(.center)
                            } else if currentPage == 2 {
                                Text("Real-time iCloud sync")
                                    .bold()
                                    .font(.title2)
                                    .multilineTextAlignment(.center)

                                Text("Saw a post that you like and wish to see it on another device? Just open the app, and if the device is linked with your iCloud account, it will show up instantly.")
                                    .multilineTextAlignment(.center)
                            }
                        }
                            .frame(width: geometry.size.width,
                                   height: geometry.size.height)
                    }
                }
            }
            .content
            .offset(x: self.isUserSwiping ? self.offset : CGFloat(self.index) * -geometry.size.width)
            .frame(width: geometry.size.width, alignment: .leading)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        self.isUserSwiping = true
                        self.offset = value.translation.width + -geometry.size.width * CGFloat(self.index)
                    })
                    .onEnded({ value in
                        if value.predictedEndTranslation.width < geometry.size.width / 2, self.index < 3 - 1 {
                            self.index += 1
                        }
                        if value.predictedEndTranslation.width > geometry.size.width / 2, self.index > 0 {
                            self.index -= 1
                        }
                        withAnimation {
                            self.isUserSwiping = false
                        }
                    })
            )
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
