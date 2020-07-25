//
//  AttachmentView.swift
//  Codename Starlight
//
//  Created by Alejandro Modroño Vara on 13/07/2020.
//

import SwiftUI

/// A structure that computes status attachments on demand
/// from a remote url, showing a placeholder using blurhash (if applicable),
/// or even a custom one, until the data is retrieved.
///
/// It also makes use of NSCache so that the image data is cached, so attachments
/// dont need to be reloaded.
public struct AttachmentView<Placeholder>: View where Placeholder: View {

    /// A function you can use to create a placeholder users will see before the image is actually loaded.
    public let placeholder: Placeholder

    public let description: String?

    /// An ObservableObject that is used to be notified whenever the image data is available.
    @ObservedObject private var remoteImageModel: RemoteImageModel

    public var body: some View {

        VStack {
            if let remoteImage = self.remoteImageModel.image {

                if let description = self.description {
                    Image(uiImage: remoteImage)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .help(description)
                        .accessibility(label: Text(description))
                } else {

                    Image(uiImage: remoteImage)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)

                }

            } else {

                self.placeholder

            }
        }
//            .matchedGeometryEffect(id: "geoeffect1", in: nspace)

    }

}

extension AttachmentView where Placeholder: View {

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
    public init(from urlString: String?, @ViewBuilder placeholder: () -> Placeholder) {
        self.remoteImageModel = RemoteImageModel(urlString)
        self.placeholder = placeholder()
        self.description = nil
    }

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
    ///     - description: A brief description of the image, used for accessibility users.
    ///     - placeholder: The view builder that generates the placeholder to be shown until the avatar
    ///       data is retrieved.
    public init(from urlString: String?, description: String, @ViewBuilder placeholder: () -> Placeholder) {
        self.remoteImageModel = RemoteImageModel(urlString)
        self.placeholder = placeholder()
        self.description = description
    }

}

struct AttachmentView_Previews: PreviewProvider {

    @State static var image: UIImage = UIImage.init()

    static var previews: some View {
        AttachmentView(
            from: "https://files.mastodon.social/cache/media_attachments/files/104/496/498/501/770/612/original/b9c7a301dd755f73.jpeg",
            placeholder: {
                Rectangle()
                    .scaledToFit()
                    .cornerRadius(10)
            }
        )
    }
}
