//
//  RemoteGalleryView.swift
//  Codename Starlight
//
//  Created by Alejandro Modroño Vara on 27/7/20.
//

import SwiftUI
import URLImage

struct RemoteGalleryView: View {

    var data = [Attachment]()

    @State var redraw: Bool = false

    var body: some View {

        HStack {

            URLImage(URL(string: self.data[0].previewURL!)!,
                placeholder: { _ in
                    Image("sotogrande")
                        .resizable()
                        .mask(
                            Rectangle()
                                .cornerRadius(
                                    15,
                                    corners: self.data.count > 2 ? [.topLeft, .bottomLeft] : [.topLeft, .topRight, .bottomLeft, .bottomRight]
                                )
                        )
                        .redacted(reason: .placeholder)
                },
                content: {
                    $0.image
                        .resizable()
                        .if(self.data.count < 2) {
                            $0.scaledToFit()
                        }
                        .mask(Rectangle()
                                .cornerRadius(
                                    15,
                                    corners: self.data.count > 2 ? [.topLeft, .bottomLeft] : [.topLeft, .topRight, .bottomLeft, .bottomRight]
                                )
                        )
                        .help(self.data[0].description ?? "Image")
                        .accessibility(
                            label: Text(
                                self.data[0].description ?? "An image without description."
                                )
                        )
                }
            )

            if self.data.count > 2 {
                VStack {

                    URLImage(URL(string: self.data[0].previewURL!)!,
                        placeholder: { _ in
                            Image("sotogrande")
                                .resizable()
                                .mask(
                                    Rectangle()
                                        .cornerRadius(
                                            15,
                                            corners: self.data.count > 3 ? [.topRight] : [.topRight, .bottomRight]
                                        )
                                )
                                .redacted(reason: .placeholder)
                        },
                        content: {
                            $0.image
                                .resizable()
                                .mask(
                                    Rectangle()
                                        .cornerRadius(
                                            15,
                                            corners: self.data.count > 3 ? [.topRight] : [.topRight, .bottomRight]
                                        )
                                )
                                .help(self.data[0].description ?? "Image")
                                .accessibility(
                                    label: Text(
                                        self.data[0].description ?? "An image without description."
                                        )
                                )
                        }
                    )

                    if self.data.count > 3 {
                        URLImage(URL(string: self.data[0].previewURL!)!,
                            placeholder: { _ in
                                Image("sotogrande")
                                    .resizable()
                                    .mask(Rectangle().cornerRadius(15, corners: [.bottomRight]))
                                    .redacted(reason: .placeholder)
                            },
                            content: {
                                $0.image
                                    .resizable()
                                    .mask(Rectangle().cornerRadius(15, corners: [.bottomRight]))
                                    .help(self.data[0].description ?? "Image")
                                    .accessibility(
                                        label: Text(
                                            self.data[0].description ?? "An image without description."
                                            )
                                    )
                                    .if(self.data.count > 4) {
                                        $0.blur(radius: 20).overlay(
                                            VStack {
                                                if self.data.count > 4 {
                                                    Text("\(self.data.count - 4)+")
                                                }
                                            }
                                        )
                                    }
                            }
                        )
                    }

                }
            }

        }
            .frame(height: 200)
    }

}

struct RemoteGalleryView_Previews: PreviewProvider {

    static var previews: some View {
        RemoteGalleryView()
    }
}
