//
//  ProfileCard.swift
//  ProfileCard
//
//  Created by Marquis Kurt on 24/7/21.
//

import SwiftUI
import Chica

struct ProfileCard: View {
    @State private var profile: Account?
    @State private var profileName: String = "Fediverse Account"
    
    public enum ProfileImageSize: CGFloat {
        case small = 32
        case medium = 56
        case large = 64
    }
    
    var imageSize: ProfileImageSize = .large
    
    var body: some View {
        HStack(spacing: 8) {
            ProfileImage()
                .frame(maxWidth: imageSize.rawValue)
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
            try await emojifyProfileName()
        } }
    }
    
    func fetchProfile() async throws {
        profile = try await Chica.shared.request(.get, for: .verifyAccountCredentials)
    }
    
    func emojifyProfileName() async throws {
        profileName = await profile?.displayName.emojified() ?? profile?.username ?? "Fediverse Account"
    }
}

struct ProfileCard_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCard()
    }
}
