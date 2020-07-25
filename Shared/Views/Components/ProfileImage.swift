//
//  ProfileImage.swift
//  Codename Starlight
//
//  Created by Alejandro Modroño Vara on 11/07/2020.
//

import SwiftUI

/// A structure that computes mastodon account avatars on demand
/// from a remote url, showing a placeholder until the data is retrieved.
///
/// It also makes use of NSCache so that the image data is cached, so images
/// dont need to be reloaded.
public struct ProfileImage<Placeholder>: View where Placeholder: View {

    /// A function you can use to create a placeholder users will see before the image is actually loaded.
    public let placeholder: Placeholder

    /// An ObservableObject that is used to be notified whenever the image data is available.
    @ObservedObject private var remoteImageModel: RemoteImageModel

    /// The size for the profile image.
    public var size: CGFloat

    public var body: some View {

        VStack {
            if let remoteImage = self.remoteImageModel.image {

                Image(uiImage: remoteImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
                    .clipShape(Circle())

            } else {

                self.placeholder

            }
        }
            .animation(.spring())

    }

    var defaultImage = UIImage(named: "NewsIcon")
}

extension ProfileImage where Placeholder: View {

    /// Generates a View that retrieves image data from a remote URL
    /// (usually decoded from JSON), that automatically changes across updates;
    /// and caches it.
    ///
    /// It's important that `content` makes use of the escaping closure to display the image,
    /// or else anything will be displayed. If a problem occurs while retrieving the data, an
    /// error message will be provided. You should log that and maybe show a simple message to the user.
    ///
    /// - Parameters:
    ///     - from: The ``Account``'s static avatar url ``CachedRemoteImage`` uses to retrieve the data.
    ///     - placeholder: The view builder that generates the placeholder to be shown until the avatar
    ///       data is retrieved.
    ///     - size: The size of the image. Defaults to 50.0.
    public init(from urlString: String?, @ViewBuilder placeholder: () -> Placeholder, size: CGFloat = 50) {
        self.remoteImageModel = RemoteImageModel(urlString)
        self.placeholder = placeholder()
        self.size = size
    }

}

struct CachedRemoteImage_Previews: PreviewProvider {

    @State static var image: UIImage = UIImage.init()

    static var previews: some View {
        ProfileImage(
            from: "https://files.mastodon.social/accounts/avatars/000/000/001/original/d96d39a0abb45b92.jpg",
            placeholder: {
                Circle()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
            }
        )
    }
}
