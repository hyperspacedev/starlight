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

    var body: some View {
        VStack {
            Text("What are your interests?")
                .font(.title)
                .bold()
            Text("Tap on the topics that interest you.")
            GeometryReader { geometry in
                SpriteView(scene: self.getMagneticView(size: geometry.size))
            }
            Spacer()
            NavigationLink(destination: Text("Big Chungus")) {
                Text("Next")
                    .bold()
                    .padding()
            }
        }
    }

    func getMagneticView(size: CGSize) -> Magnetic {
        let magnet = Magnetic(size: size)
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
            magnet.addChild(node)
        }
        return magnet
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
