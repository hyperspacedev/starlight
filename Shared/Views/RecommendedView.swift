//
//  RecommendedView.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/13/20.
//

import SwiftUI

struct RecommendedView: View {
    var body: some View {
        List {
            RecommendedProfile(imageName: "amethyst", name: "Amethyst", user: "@amethyst")
            RecommendedProfile(imageName: "curtis", name: "Curtis Smith", user: "@asalways")
            RecommendedProfile(imageName: "pointFlash", name: "Point Flash", user: "@iamnotabug")
            RecommendedProfile(imageName: "amodrono", name: "amodrono", user: "@amodrono@mastodon.technology")
        }
        .navigationTitle("Recommended")
        .listStyle(InsetGroupedListStyle())
    }
}

struct RecommendedView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendedView()
    }
}
