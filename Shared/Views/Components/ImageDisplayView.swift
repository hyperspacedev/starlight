//
//  ImageDisplayView.swift
//  Codename Starlight
//
//  Created by Alejandro Modroño Vara on 13/07/2020.
//

import SwiftUI
import Combine

/// A structure that allows users to see an image scaled in a simple view.
public struct ImageDisplayView<Content>: View where Content: View {

    @Namespace var nspace

    public let content: Content
    public var image: Image
    public var description: String
    @State public var shouldDisplayUI: Bool = false
    @Binding public var shouldOpen: Bool

    public var body: some View {
        ZStack {

            Text(self.shouldOpen ? "true" : "false")
                .padding(.bottom, 50)

            self.content
                .matchedGeometryEffect(id: "transitionToImageView", in: nspace)

            if shouldOpen {
                self.view
                    .matchedGeometryEffect(id: "transitionToImageView", in: nspace)
            }

        }
            .animation(.spring())
    }

    var view: some View {

        ZStack(alignment: .topLeading) {

            Color.black
                .onTapGesture {
                    self.shouldDisplayUI.toggle()
                }

            if shouldDisplayUI {

                Button(action: {
                    self.shouldOpen.toggle()
                }, label: {
                    Image(systemName: "xmark")
                        .imageScale(.large)
                })
                    .padding(30)
                    .font(.headline)

            }

            VStack {

                Spacer()

                self.image
                    .resizable()
                    .scaledToFit()

                Spacer()

            }
//                .padding()

            if shouldDisplayUI {

                VStack {

                    Spacer()

                    HStack {

                        Spacer()

                        Text(self.description)

                        Spacer()

                    }

                }
                    .padding()

            }

        }
            .animation(.spring())
            .foregroundColor(.white)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.shouldDisplayUI.toggle()
                }
            }

    }

}

extension ImageDisplayView where Content: View {

    /// Creates a view that allows users to see static media (images).
    ///
    /// - Parameters:
    ///   - image: The image to be displayed.
    ///   - description: A brief description for accessibility users.
    ///   - shouldOpen: A binding that notifies the view when to open.
    ///   - content: A view builder that creates the view.
    public init(image: Image, description: String, shouldOpen: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self.image = image
        self.description = description
        self._shouldOpen = shouldOpen
        self.content = content()
    }

}

struct ImageDisplayView_Previews: PreviewProvider {

    @State static var shouldOpen: Bool = true

    static var previews: some View {
        ImageDisplayView(image: Image("sotogrande"), description: "Sotogrande seen from above.", shouldOpen: self.$shouldOpen) {

            VStack {
                Spacer()
                Button(action: {
                    self.shouldOpen.toggle()
                }, label: {

                    AttachmentView(
                        from: "https://files.mastodon.social/cache/media_attachments/files/104/496/498/501/770/612/original/b9c7a301dd755f73.jpeg",
                        placeholder: {
                            Rectangle()
                                .scaledToFit()
                                .cornerRadius(10)
                        }
                    )

                })
                    .buttonStyle(PlainButtonStyle())
                Spacer()
            }

        }
    }
}
