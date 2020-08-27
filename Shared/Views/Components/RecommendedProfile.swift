//
//  RecommendedProfile.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/12/20.
//

import SwiftUI

struct RecommendedProfile: View {

    @State var imageName: String
    @State var name: String
    @State var user: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(maxWidth: 64)
            VStack(alignment: .leading) {
                Text(name)
                    .font(.title2)
                    .bold()
                    .lineLimit(1)
                Text(user)
                    .lineLimit(1)
                Text("No bio provided.")
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

        }
        .padding(4)
    }
}

struct RecommendedProfile_Previews: PreviewProvider {
    static var previews: some View {
        RecommendedProfile(imageName: "amodrono", name: "Test User", user: "@testacct")
    }
}
