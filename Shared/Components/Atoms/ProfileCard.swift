//
//  ProfileCard.swift
//  ProfileCard
//
//  Created by Marquis Kurt on 24/7/21.
//

import SwiftUI
import Chica

/// A component that displays a profile picture, display name, and account information.
struct ProfileCard: View {
    @State private var profile: Account?
    @State private var profileName: String = "Fediverse Account"
    
    /// The size of the profile image to use.
    ///
    /// - SeeAlso: ``ProfileImage.size``
    var imageSize: ProfileImage.Size = .large
    
    var body: some View {
        HStack(spacing: 8) {
            ProfileImage(for: .currentUser, size: imageSize)
            VStack(alignment: .leading) {
                Text(profileName)
                    .font(.system(.title, design: .rounded))
                    .bold()
                Text("@\(profile?.acct ?? "account")")
            }
        }
        .font(.system(.body, design: .rounded))
        .onAppear { Task.init {
            try await fetchProfile()
            try emojifyProfileName()
        } }
    }
    
    private func fetchProfile() async throws {
        profile = try await Chica.shared.request(.get, for: .verifyAccountCredentials)
    }
    
    private func emojifyProfileName() throws {
        profileName = profile?.getName().emojified() ?? "Fediverse Account"
    }
}

struct ProfileCard_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCard()
    }
}
