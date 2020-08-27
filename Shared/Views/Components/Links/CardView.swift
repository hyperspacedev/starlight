//
//  CardView.swift
//  Codename Starlight
//
//  Created by Alejandro Modroño Vara on 2/8/20.
//

import Foundation
import SwiftUI
import LinkPresentation
import URLImage

struct CardView: View {

    var card: Card
    var isMain: Bool

    @State var openLink: Bool = false
    @State var redraw: Bool = false

    #if os(macOS)
    // Note: Need to subtract sidebar size here.
    let bounds: CGFloat = NSApplication.shared.mainWindow?.frame.width
    #else
    let bounds: CGFloat = UIScreen.main.bounds.width
    #endif

    var body: some View {
        VStack {
            if self.card.type == .link && !self.card.url.contains("twitter.com") {

                if self.card.image != nil {
                    self.cardView
                } else {
                    self.compactCardView
                }

            } else {

                LinkRow(previewURL: URL(string: self.card.url)!, redraw: self.$redraw)
                    .aspectRatio(contentMode: .fit)
                    .if(!isMain) {
                        $0.frame(width: bounds - 120)
                    }

            }
        }
            .fullScreenCover(isPresented: self.$openLink, content: {
                SafariView(url: URL(string: self.card.url)!).edgesIgnoringSafeArea(.all)
            })
    }

    var cardView: some View {

        Button(action: { self.openLink.toggle() }, label: {
            VStack {

                URLImage(URL(string: self.card.image!)!,
                    placeholder: { _ in
                        Image("sotogrande")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(15, corners: [.topLeft, .topRight])
                            .redacted(reason: .placeholder)
                    },
                    content: {
                        $0.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(15, corners: [.topLeft, .topRight])
                    }
                )

                VStack(alignment: .leading, spacing: 5) {

                    Text("\(card.title)")
                        .lineLimit(2)

                    Text("\(card.url.fixURL())")
                        .lineLimit(1)
                        .foregroundColor(.secondary)
                        .font(.callout)

                }
                .padding([.horizontal, .bottom])

            }
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(customColor("cardBorder"), lineWidth: 1)
                )
        })
            .buttonStyle(PlainButtonStyle())

    }

    var compactCardView: some View {

        Button(action: { self.openLink.toggle() }, label: {
            HStack {

                if let image = card.image {
                    RemoteImage(
                        from: image,
                        redraw: self.$redraw,
                        placeholder: {
                            Rectangle()
                                .foregroundColor(.gray)
                                .frame(width: 70, height: 70)
                                .cornerRadius(15, corners: [.topLeft, .bottomLeft])
                        },
                        result: { image in
                            image
                                .aspectRatio(contentMode: .fit)
                                .scaledToFit()
                                .frame(maxWidth: 70, maxHeight: 70)
                                .cornerRadius(15, corners: [.topLeft, .bottomLeft])
                        }
                    )
                } else {

                    Rectangle()
                        .foregroundColor(customColor("cardBackground"))
                        .frame(width: 70, height: 70)
                        .cornerRadius(15, corners: [.topLeft, .bottomLeft])
                        .overlay(
                            Image(systemName: "link")
                                .font(.headline)
                                .foregroundColor(customColor("cardItem"))
                                .imageScale(.large)
                                .padding()
                        )

                }

                VStack(alignment: .leading, spacing: 5) {

                    Text("\(card.title)")
                        .lineLimit(2)

                    Text("\(card.url.fixURL())")
                        .lineLimit(1)
                        .foregroundColor(.secondary)
                        .font(.callout)

                }
                    .padding(.trailing)

            }
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(customColor("cardBorder"), lineWidth: 1)
                )
        })
            .buttonStyle(PlainButtonStyle())

    }

}

struct LinkRow: UIViewRepresentable {

    var previewURL: URL

    @Binding var redraw: Bool

    func makeUIView(context: Self.Context) -> LPLinkView {
        let view = LPLinkView(url: previewURL)

        let provider = LPMetadataProvider()

        provider.startFetchingMetadata(for: previewURL) { (metadata, _) in
            if let metadata = metadata {
                DispatchQueue.main.async {
                    view.metadata = metadata
                    view.sizeToFit()
                    self.redraw.toggle()
                }
            }
        }

        return view
    }

    func updateUIView(_ uiView: LPLinkView, context: UIViewRepresentableContext<LinkRow>) {
    }

}
