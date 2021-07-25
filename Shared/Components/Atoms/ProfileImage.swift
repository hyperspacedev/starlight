//
//  ProfileImage.swift
//  ProfileImage
//
//  Created by Marquis Kurt on 24/7/21.
//

import SwiftUI
import Chica

/// A convenience view for presenting an image of the current user's avatar.
struct ProfileImage: View {
    @State private var account: Account?
    
    var body: some View {
        AsyncImage(url: URL(string: account?.avatarStatic ?? "")) { phase in
            switch(phase) {
            case .empty:
                ProgressView()
                    .padding()
                    .background(
                        Color.gray
                            .clipShape(Circle())
                    )
                    .frame(maxWidth: 64)
            case .failure:
                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 64)
            case .success(let image):
                image.resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(maxWidth: 64)
            @unknown default:
                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 64)
            }
        }
        .onAppear {
            Task.init {
                try await fetchProfile()
            }
        }
    }
    
    private func fetchProfile() async throws {
        account = try await Chica.shared.request(.get, for: .verifyAccountCredentials)
    }
}

struct ProfileImage_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImage()
    }
}
