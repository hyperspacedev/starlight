//
//  ProfileCard.swift
//  ProfileCard
//
//  Created by Marquis Kurt on 24/7/21.
//

import SwiftUI
import Chica

struct ProfileCard: View {
    @State var profile: Account?
    
    var body: some View {
        HStack {
            ProfileImage()
            VStack(alignment: .leading) {
                Text(profile?.displayName.emojified() ?? "Fediverse Account")
                    .font(.system(.title, design: .rounded))
                    .bold()
                Text("@\(profile?.acct ?? "account")")
            }
        }
        .font(.system(.body, design: .rounded))
        .onAppear { Task.init { try await fetchProfile() } }
    }
    
    func fetchProfile() async throws {
        profile = try await Chica.shared.request(.get, for: .verifyAccountCredentials)
    }
}

struct ProfileCard_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCard()
    }
}
