//
//  VideoMediaView.swift
//  Starlight
//
//  Created by Alejandro Modroño Vara on 31/10/20.
//

import SwiftUI
import AVKit
import URLImage

struct VideoMediaView: View {

    var videoURL: String
    var previewURL: String
    var type: AttachmentType = .video

    @State var isPlaying: Bool = false

    var body: some View {

        let player = AVPlayer(url: URL(string: self.videoURL)!)

        return VStack {
            if !self.isPlaying {
                URLImage(
                    URL(string: self.previewURL)!,
                    placeholder: { _ in
                        Image("sotogrande")
                            .scaledWithoutStretching()
                            .redacted(reason: .placeholder)
                    },
                    content: {
                        $0.image
                            .scaledWithoutStretching()
                            .overlay(
                                Image(systemName: "play.circle.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white)
                            )
                            .if(self.type == .gifv, content: {
                                $0.overlay(
                                    Text("GIF")
                                        .padding()
                                        .font(.headline)
                                        .foregroundColor(.black)
                                        .background(Color.white.cornerRadius(10))
                                        .padding(),
                                    alignment: .bottomTrailing
                                )
                            })
                            .onTapGesture {
                                self.isPlaying.toggle()
                            }
                    }
                )
            } else {
                VideoPlayer(player: player)
                    .onAppear {

                        //  Enable autoplay
                        player.play()

                        if self.type == .gifv {

                            // Replay the video when finished
                            // swiftlint:disable:next discarded_notification_center_observer
                            NotificationCenter.default.addObserver(
                                forName: .AVPlayerItemDidPlayToEndTime,
                                object: nil,
                                queue: nil
                            ) { _ in
                                player.seek(to: CMTime.zero)
                                player.play()
                            }

                        }

                    }
            }
        }

    }
}
