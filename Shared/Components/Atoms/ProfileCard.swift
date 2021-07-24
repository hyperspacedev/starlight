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
            avatar
            VStack(alignment: .leading) {
                Text(profile?.displayName ?? "Sign In")
                    .font(.system(.title, design: .rounded))
                    .bold()
                Text(profile?.acct ?? "Account name")
            }
        }
        .font(.system(.body, design: .rounded))
        .onAppear { Task.init { try await fetchProfile() } }
    }
    
    var avatar: some View {
        AsyncImage(url: URL(string: profile?.avatarStatic ?? "")) { phase in
            switch(phase) {
            case .empty:
                ProgressView()
                    .padding()
                    .background(
                        Color.gray
                            .clipShape(Circle())
                    )
                    .frame(maxWidth: 76)
            case .failure:
                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 76)
            case .success(let image):
                image.resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(maxWidth: 76)
            @unknown default:
                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 76)
            }
        }
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
