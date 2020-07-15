//
//  RemoteImage.swift
//  Codename Starlight
//
//  Created by Alejandro Modroño Vara on 14/07/2020.
//

import Foundation
import SwiftUI
import UIKit

extension Image {

    func remote(from url: String) -> Image {
        let remoteImageModel = RemoteImageModel(url)

        if let remoteImage = remoteImageModel.image {
            return Image(uiImage: remoteImage)
        }

        return self

    }

}

struct RemoteImage_Previews: PreviewProvider {
    static var previews: some View {
        Image("amodrono")
            .remote(
                from: "https://files.mastodon.social/cache/media_attachments/files/104/496/498/501/770/612/original/b9c7a301dd755f73.jpeg")
            .resizable()
            .scaledToFit()
    }
}
