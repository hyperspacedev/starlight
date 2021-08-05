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
    
    enum AccountType {
        case currentUser
        case user(id: String)
    }
    
    /// Instantiate a profile image view.
    /// - Parameter account: The account to fetch the image data from.
    /// - Parameter size: The size of the profile image. Defaults to `.large`.
    init(for account: AccountType, size: Size = .large) {
        self.accountType = account
        self.size = size
    }
    
    @State private var account: Account?
    
    /// The size of the image to use.
    ///
    /// Defaults to `ProfileImage.Size.large`.
    @State var size: ProfileImage.Size
    
    /// The account that the image is being fetched from.
    @State var accountType: AccountType
    
    enum Size: CGFloat {
        case small = 32
        case medium = 56
        case large = 64
    }
    
    var body: some View {
        AsyncImage(url: URL(string: account?.getAvatar() ?? "")) { phase in
            switch(phase) {
            case .empty:
                ProgressView()
                    .padding()
            case .failure:
                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFit()
            case .success(let image):
                image.resizable()
                    .scaledToFit()
                    .clipShape(Circle())
            @unknown default:
                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFit()
            }
        }
        .frame(maxWidth: size.rawValue)
        .onAppear {
            Task.init {
                try await fetchProfile()
            }
        }
    }
    
    private func fetchProfile() async throws {
        switch accountType {
        case .currentUser:
            account = try await Chica.shared.request(.get, for: .verifyAccountCredentials)
        case .user(let id):
            account = try await Chica.shared.request(.get, for: .account(id: id))
        }
    }
}

struct ProfileImage_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImage(for: .currentUser)
    }
}
