//
//  CachedRemoteImage.swift
//  Codename Starlight
//
//  Created by Alejandro Modroño Vara on 11/07/2020.
//

//import SwiftUI
//import UIKit
//
///// A structure that computes views on demand from an underlying collection of
///// of identified data.
//public struct ForEach<Data, ID, Content> where Data : RandomAccessCollection, ID : Hashable {
//
//    /// The collection of underlying identified data that SwiftUI uses to create
//    /// views dynamically.
//    public var data: Data
//
//    /// A function you can use to create content on demand using the underlying
//    /// data.
//    public var content: (Data.Element) -> Content
//}
//
//@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
//extension ForEach : View where Content : View {
//
//    /// The type of view representing the body of this view.
//    ///
//    /// When you create a custom view, Swift infers this type from your
//    /// implementation of the required `body` property.
//    public typealias Body = Never
//}
//
//@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
//extension ForEach where ID == Data.Element.ID, Content : View, Data.Element : Identifiable {
//
//    /// Creates an instance that uniquely identifies and creates views across
//    /// updates based on the identity of the underlying data.
//    ///
//    /// It's important that the `id` of a data element doesn't change unless you
//    /// replace the data element with a new data element that has a new
//    /// identity. If the `id` of a data element changes, the content view
//    /// generated from that data element loses any current state and animations.
//    ///
//    /// - Parameters:
//    ///   - data: The identified data that the ``ForEach`` instance uses to
//    ///     create views dynamically.
//    ///   - content: The view builder that creates views dynamically.
//    public init(_ data: Data, @ViewBuilder content: @escaping (Data.Element) -> Content)
//}
//
//@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
//extension ForEach where Content : View {
//
//    /// Creates an instance that uniquely identifies and creates views across
//    /// updates based on the provided key path to the underlying data's
//    /// identifier.
//    ///
//    /// It's important that the `id` of a data element doesn't change, unless
//    /// SwiftUI considers the data element to have been replaced with a new data
//    /// element that has a new identity. If the `id` of a data element changes,
//    /// then the content view generated from that data element will lose any
//    /// current state and animations.
//    ///
//    /// - Parameters:
//    ///   - data: The data that the `ForEach` instance uses to create views
//    ///     dynamically.
//    ///   - id: The key path to the provided data's identifier.
//    ///   - content: The view builder that creates views dynamically.
//    public init(_ data: Data, id: KeyPath<Data.Element, ID>, @ViewBuilder content: @escaping (Data.Element) -> Content)
//}
//
//@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
//extension ForEach where Data == Range<Int>, ID == Int, Content : View {
//
//    /// Creates an instance that computes views on demand over a given constant
//    /// range.
//    ///
//    /// The instance only reads the initial value of the provided `data` and
//    /// doesn't need to identify views across updates. To compute views on
//    /// demand over a dynamic range, use ``ForEach/init(_:id:content:)``.
//    ///
//    /// - Parameters:
//    ///   - data: A constant range.
//    ///   - content: The view builder that creates views dynamically.
//    public init(_ data: Range<Int>, @ViewBuilder content: @escaping (Int) -> Content)
//}
//
///// A structure that computes images on demand from an remote url, showing
///// a placeholder until the data is retrieved.
/////
///// It also makes use of NSCache so that the image data is cached so images dont need to be reloaded
//public struct CachedRemoteImage<Placeholder, FinalImage>: View where Placeholder: View, FinalImage: View {
//
//    /// A function you can use to create a placeholder users will see before the image is actually loaded.
//    public let placeholder: Placeholder
//
//    /// A function you can use to create content on demand using the underlying
//    /// data.
//    public let image: (UIImage) -> FinalImage
//
//    /// An ObservableObject that is used to be notified whenever the image data is available.
//    @ObservedObject private var urlImageModel: UrlImageModel
//
//    public var body: some View {
//
//        VStack {
//            if let remoteImage = self.urlImageModel.image {
//
//                self.image
//
//            } else {
//
//                self.placeholder
//
//            }
//        }
//            .animation(.spring())
//
//    }
//
//    var defaultImage = UIImage(named: "NewsIcon")
//}
//
//extension CachedRemoteImage where FinalImage : View {
//
//    /// Generates a View that retrieves image data from a remote URL
//    /// (usually decoded from JSON), that automatically changes across updates;
//    /// and caches it.
//    ///
//    /// It's important that `content` makes use of the escaping closure to display the image,
//    /// or else anything will be displayed. If a problem occurs while retrieving the data, an
//    /// error message will be provided. You should log that and maybe show a simple message to the user.
//    ///
//    /// - Parameters:
//    ///     - from: The url `CachedRemoteImage` uses to load the image.
//    ///     - placeholder: The view builder that generates the placeholder to be shown before the image data is retrieved.
//    ///     - image: A function you can use to create content on demand using the underlying data.
//    public init(from urlString: String?, @ViewBuilder placeholder: () -> Placeholder, @ViewBuilder image: @escaping (UIImage) -> FinalImage) {
//        urlImageModel = UrlImageModel(urlString: urlString)
//        self.placeholder = placeholder()
//        self.image = image
//    }
//
//}
//
//struct CachedRemoteImage_Previews: PreviewProvider {
//
//    @State static var image: UIImage = UIImage.init()
//
//    static var previews: some View {
//        CachedRemoteImage(
//            from: "https://files.mastodon.social/accounts/avatars/000/000/001/original/d96d39a0abb45b92.jpg",
//            placeholder: {
//                Circle()
//                    .scaledToFit()
//                    .frame(width: 100, height: 100)
//                    .foregroundColor(.gray)
//            },
//            completion: {
//                self.image =
//            })
//    }
//}
