//
//  RegisterView.swift
//  Hyperspace
//
//  Created by Marquis Kurt on 10/1/20.
//

import SwiftUI
import SpriteKit
import Magnetic

struct RegisterView: View {

    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10) {

                if self.presentationMode.wrappedValue.isPresented {
                    Button("\(Image(systemName: "arrow.left")) Back", action: {
                        self.presentationMode.wrappedValue.dismiss()
                    })
                    .foregroundColor(Color(.label))
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                }

                Text("What interests you?")
                    .font(.system(size: 35, weight: .bold, design: .rounded))

                VStack(alignment: .leading) {
                    Text("The fediverse is really big, and finding the instance that best fits you might be a bit complicated.\n")
                    Text("Tap on topics that you find interesting. We'll use this to help find an instance for you.")
                }
                    .foregroundColor(Color("textColor"))
                    .font(.system(size: 17, weight: .medium, design: .rounded))
            }
            .padding()

            GeometryReader { geometry in
                SpriteView(scene: self.getMagneticView(size: geometry.size))
            }

            NavigationLink(destination: instanceList) {
                Text("Next")
                    .bold()
                    .padding()
            }

        }
        .navigationBarHidden(true)
    }

    func getMagneticView(size: CGSize) -> Magnetic {
        let magnet = Magnetic(size: size)
        magnet.backgroundColor = .systemBackground
        let defaultSize = CGFloat(40)
        let nodes = [
            Node(text: "Tech", image: UIImage(named: "tech"), color: .systemRed, radius: defaultSize),
            Node(text: "History", image: UIImage(named: "history"), color: .systemBlue, radius: defaultSize),
            Node(text: "Music", image: UIImage(named: "music"), color: .systemGreen, radius: defaultSize),
            Node(text: "Art", image: UIImage(named: "art"), color: .systemPurple, radius: defaultSize),
            Node(text: "Gaming", image: UIImage(named: "gaming"), color: .systemYellow, radius: defaultSize),
            Node(text: "Politics", image: UIImage(named: "politics"), color: .systemOrange, radius: defaultSize),
            Node(text: "Poetry", image: UIImage(named: "poetry"), color: .systemIndigo, radius: defaultSize),
            Node(text: "Science", image: UIImage(named: "science"), color: .systemBlue, radius: defaultSize),
            Node(text: "Fitness", image: UIImage(named: "fitness"), color: .systemPink, radius: defaultSize)
        ]

        for node in nodes {
            node.strokeColor = .systemBackground
            magnet.addChild(node)
        }
        return magnet
    }

    var instanceList: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                VStack {
                    HStack {
                        Text("Recommended instances")
                            .font(.title2)
                            .bold()

                        Spacer()

                        NavigationLink("See all \(Image(systemName: "chevron.right"))", destination: recommendedInstanceList)
                    }

                    ScrollView(.horizontal, content: {

                        HStack(spacing: 20) {
                            ForEach(0 ..< 3) { _ in
                                NavigationLink(destination: InstanceView()) {
                                    HStack {

                                        Image("amodrono")
                                            .resizable()
                                            .frame(width: 70, height: 70)
                                            .cornerRadius(10)

                                        VStack {
                                            HStack {
                                                VStack(alignment: .leading) {
                                                    Text("mastodon.social")
                                                        .bold()
                                                        .foregroundColor(labelColor)

                                                    Text("378k users")
                                                        .foregroundColor(.gray)
                                                }

                                                Spacer()

                                                Button(action: {}, label: {
                                                    Text("JOIN")
                                                        .bold()
                                                        .foregroundColor(.blue)
                                                        .padding(.horizontal, 10)
                                                        .padding(5)
                                                        .background(
                                                            Color(.systemGray6).cornerRadius(30)
                                                        )
                                                })
                                                .padding()
                                            }
                                            Divider()
                                        }

                                    }
                                }
                            }
                        }

                    })
                }
                .padding()

                VStack(alignment: .leading, spacing: 20) {
                    Text("All instances")
                        .font(.title2)
                        .bold()

                    ForEach(0 ..< 10) { _ in
                        NavigationLink(destination: InstanceView()) {
                            HStack {

                                Image("amodrono")
                                    .resizable()
                                    .frame(width: 45, height: 45)
                                    .cornerRadius(30)

                                VStack {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text("mastodon.social")
                                                .bold()
                                                .foregroundColor(labelColor)

                                            Text("378k users")
                                                .foregroundColor(.gray)
                                        }

                                        Spacer()

                                        Button(action: {}, label: {
                                            Text("JOIN")
                                                .bold()
                                                .foregroundColor(.blue)
                                                .padding(.horizontal, 10)
                                                .padding(5)
                                                .background(
                                                    Color(.systemGray6).cornerRadius(30)
                                                )
                                        })
                                        .padding(.trailing)
                                    }
                                    Divider()
                                }

                            }
                        }
                    }
                }
                .padding(.leading)
                Spacer()
            }
            .navigationTitle("Results")
            .navigationBarSearch(.constant(""))
        }
    }

    var recommendedInstanceList: some View {
        ScrollView {
            ForEach(0 ..< 10) { _ in
                NavigationLink(destination: InstanceView()) {
                    HStack {

                        Image("amodrono")
                            .resizable()
                            .frame(width: 45, height: 45)
                            .cornerRadius(30)

                        VStack {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("mastodon.social")
                                        .bold()
                                        .foregroundColor(labelColor)

                                    Text("378k users")
                                        .foregroundColor(.gray)
                                }

                                Spacer()

                                Button(action: {}, label: {
                                    Text("JOIN")
                                        .bold()
                                        .foregroundColor(.blue)
                                        .padding(.horizontal, 10)
                                        .padding(5)
                                        .background(
                                            Color(.systemGray6).cornerRadius(30)
                                        )
                                })
                                .padding(.trailing)
                            }
                            Divider()
                        }

                    }
                }
            }
            .padding(.leading)
        }
        .navigationTitle("Recommended")
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RegisterView().instanceList
        }
    }
}
