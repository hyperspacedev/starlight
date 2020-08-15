//
//  RemoteGalleryView.swift
//  Codename Starlight
//
//  Created by Alejandro Modroño Vara on 27/7/20.
//

import SwiftUI

struct RemoteGalleryView: View {

    var data: [Image]

    var body: some View {
        ForEach(data) { _ in

        }
    }
}

struct GalleryView_Previews: PreviewProvider {

    static let data = [Image("sotogrande"), Image("sotogrande"), Image("sotogrande")]

    static var previews: some View {
        RemoteGalleryView(data: self.data)
    }
}
