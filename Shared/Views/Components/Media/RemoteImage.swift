//
//  RemoteImage.swift
//  Codename Starlight
//
//  Created by Alejandro Modroño Vara on 14/07/2020.
//

import Foundation
import SwiftUI

///// A view that displays an environment-dependent image.
/////
///// An `Image` is a late-binding token; the system resolves its actual value
///// only when it's about to use the image in a given environment.
//@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
//@frozen public struct Image : Equatable {
//
//    /// Returns a Boolean value indicating whether two values are equal.
//    ///
//    /// Equality is the inverse of inequality. For any values `a` and `b`,
//    /// `a == b` implies that `a != b` is `false`.
//    ///
//    /// - Parameters:
//    ///   - lhs: A value to compare.
//    ///   - rhs: Another value to compare.
//    public static func == (lhs: Image, rhs: Image) -> Bool {
//        
//    }
//}
//
//@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
//extension Image {
//
//    /// Creates a labeled image that you can use as content for controls.
//    ///
//    /// - Parameters:
//    ///   - name: the name of the image resource to lookup, as well as the
//    ///     localization key with which to label the image.
//    ///   - bundle: the bundle to search for the image resource and localization
//    ///     content. If `nil`, uses the main `Bundle`. Defaults to `nil`.
//    public init(_ name: String, bundle: Bundle? = nil)
//
//    /// Creates a labeled image that you can use as content for controls, with
//    /// the specified label.
//    ///
//    /// - Parameters:
//    ///   - name: the name of the image resource to lookup
//    ///   - bundle: the bundle to search for the image resource. If `nil`, uses
//    ///     the main `Bundle`. Defaults to `nil`.
//    ///   - label: The label associated with the image. The label is used for
//    ///     things like accessibility.
//    public init(_ name: String, bundle: Bundle? = nil, label: Text)
//
//    /// Creates an unlabeled, decorative image.
//    ///
//    /// This image is ignored for accessibility purposes.
//    ///
//    /// - Parameters:
//    ///   - name: the name of the image resource to lookup
//    ///   - bundle: the bundle to search for the image resource. If `nil`, uses
//    ///     the main `Bundle`. Defaults to `nil`.
//    public init(decorative name: String, bundle: Bundle? = nil)
//
//    /// Creates a system symbol image.
//    ///
//    /// This initializer creates an image using a system-provided symbol. To
//    /// create a custom symbol image from your app's asset catalog, use
//    /// `init(_:)` instead.
//    ///
//    /// - Parameters:
//    ///   - systemName: The name of the system symbol image.
//    ///     Use the SF Symbols app to look up the names of system symbol images.
//    @available(OSX 11.0, *)
//    public init(systemName: String)
//}
//
//@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
//extension Image : View {
//
//    /// The type of view representing the body of this view.
//    ///
//    /// When you create a custom view, Swift infers this type from your
//    /// implementation of the required `body` property.
//    public typealias Body = Never
//}
//
//@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
//extension Image {
//
//    public func renderingMode(_ renderingMode: Image.TemplateRenderingMode?) -> Image
//}
//
//@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
//extension Image {
//
//    /// The orientation of an image.
//    @frozen public enum Orientation : UInt8, CaseIterable, Hashable {
//
//        case up
//
//        case upMirrored
//
//        case down
//
//        case downMirrored
//
//        case left
//
//        case leftMirrored
//
//        case right
//
//        case rightMirrored
//
//        /// The raw type that can be used to represent all values of the conforming
//        /// type.
//        ///
//        /// Every distinct value of the conforming type has a corresponding unique
//        /// value of the `RawValue` type, but there may be values of the `RawValue`
//        /// type that don't have a corresponding value of the conforming type.
//        public typealias RawValue = UInt8
//
//        /// Creates a new instance with the specified raw value.
//        ///
//        /// If there is no value of the type that corresponds with the specified raw
//        /// value, this initializer returns `nil`. For example:
//        ///
//        ///     enum PaperSize: String {
//        ///         case A4, A5, Letter, Legal
//        ///     }
//        ///
//        ///     print(PaperSize(rawValue: "Legal"))
//        ///     // Prints "Optional("PaperSize.Legal")"
//        ///
//        ///     print(PaperSize(rawValue: "Tabloid"))
//        ///     // Prints "nil"
//        ///
//        /// - Parameter rawValue: The raw value to use for the new instance.
//        public init?(rawValue: UInt8)
//
//        /// The corresponding value of the raw type.
//        ///
//        /// A new instance initialized with `rawValue` will be equivalent to this
//        /// instance. For example:
//        ///
//        ///     enum PaperSize: String {
//        ///         case A4, A5, Letter, Legal
//        ///     }
//        ///
//        ///     let selectedSize = PaperSize.Letter
//        ///     print(selectedSize.rawValue)
//        ///     // Prints "Letter"
//        ///
//        ///     print(selectedSize == PaperSize(rawValue: selectedSize.rawValue)!)
//        ///     // Prints "true"
//        public var rawValue: UInt8 { get }
//
//        /// A type that can represent a collection of all values of this type.
//        public typealias AllCases = [Image.Orientation]
//
//        /// A collection of all values of this type.
//        public static var allCases: [Image.Orientation] { get }
//    }
//}
//
//@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
//extension Image {
//
//    public enum TemplateRenderingMode {
//
//        case template
//
//        case original
//
//        /// Returns a Boolean value indicating whether two values are equal.
//        ///
//        /// Equality is the inverse of inequality. For any values `a` and `b`,
//        /// `a == b` implies that `a != b` is `false`.
//        ///
//        /// - Parameters:
//        ///   - lhs: A value to compare.
//        ///   - rhs: Another value to compare.
//        public static func == (a: Image.TemplateRenderingMode, b: Image.TemplateRenderingMode) -> Bool
//
//        /// The hash value.
//        ///
//        /// Hash values are not guaranteed to be equal across different executions of
//        /// your program. Do not save hash values to use during a future execution.
//        ///
//        /// - Important: `hashValue` is deprecated as a `Hashable` requirement. To
//        ///   conform to `Hashable`, implement the `hash(into:)` requirement instead.
//        public var hashValue: Int { get }
//
//        /// Hashes the essential components of this value by feeding them into the
//        /// given hasher.
//        ///
//        /// Implement this method to conform to the `Hashable` protocol. The
//        /// components used for hashing must be the same as the components compared
//        /// in your type's `==` operator implementation. Call `hasher.combine(_:)`
//        /// with each of these components.
//        ///
//        /// - Important: Never call `finalize()` on `hasher`. Doing so may become a
//        ///   compile-time error in the future.
//        ///
//        /// - Parameter hasher: The hasher to use when combining the components
//        ///   of this instance.
//        public func hash(into hasher: inout Hasher)
//    }
//
//    /// The scale to apply to vector images relative to text.
//    @available(OSX 11.0, *)
//    public enum Scale {
//
//        case small
//
//        case medium
//
//        case large
//
//        /// Returns a Boolean value indicating whether two values are equal.
//        ///
//        /// Equality is the inverse of inequality. For any values `a` and `b`,
//        /// `a == b` implies that `a != b` is `false`.
//        ///
//        /// - Parameters:
//        ///   - lhs: A value to compare.
//        ///   - rhs: Another value to compare.
//        public static func == (a: Image.Scale, b: Image.Scale) -> Bool
//
//        /// The hash value.
//        ///
//        /// Hash values are not guaranteed to be equal across different executions of
//        /// your program. Do not save hash values to use during a future execution.
//        ///
//        /// - Important: `hashValue` is deprecated as a `Hashable` requirement. To
//        ///   conform to `Hashable`, implement the `hash(into:)` requirement instead.
//        public var hashValue: Int { get }
//
//        /// Hashes the essential components of this value by feeding them into the
//        /// given hasher.
//        ///
//        /// Implement this method to conform to the `Hashable` protocol. The
//        /// components used for hashing must be the same as the components compared
//        /// in your type's `==` operator implementation. Call `hasher.combine(_:)`
//        /// with each of these components.
//        ///
//        /// - Important: Never call `finalize()` on `hasher`. Doing so may become a
//        ///   compile-time error in the future.
//        ///
//        /// - Parameter hasher: The hasher to use when combining the components
//        ///   of this instance.
//        public func hash(into hasher: inout Hasher)
//    }
//}
//
//@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
//extension Image {
//
//    public enum Interpolation {
//
//        case none
//
//        case low
//
//        case medium
//
//        case high
//
//        /// Returns a Boolean value indicating whether two values are equal.
//        ///
//        /// Equality is the inverse of inequality. For any values `a` and `b`,
//        /// `a == b` implies that `a != b` is `false`.
//        ///
//        /// - Parameters:
//        ///   - lhs: A value to compare.
//        ///   - rhs: Another value to compare.
//        public static func == (a: Image.Interpolation, b: Image.Interpolation) -> Bool
//
//        /// The hash value.
//        ///
//        /// Hash values are not guaranteed to be equal across different executions of
//        /// your program. Do not save hash values to use during a future execution.
//        ///
//        /// - Important: `hashValue` is deprecated as a `Hashable` requirement. To
//        ///   conform to `Hashable`, implement the `hash(into:)` requirement instead.
//        public var hashValue: Int { get }
//
//        /// Hashes the essential components of this value by feeding them into the
//        /// given hasher.
//        ///
//        /// Implement this method to conform to the `Hashable` protocol. The
//        /// components used for hashing must be the same as the components compared
//        /// in your type's `==` operator implementation. Call `hasher.combine(_:)`
//        /// with each of these components.
//        ///
//        /// - Important: Never call `finalize()` on `hasher`. Doing so may become a
//        ///   compile-time error in the future.
//        ///
//        /// - Parameter hasher: The hasher to use when combining the components
//        ///   of this instance.
//        public func hash(into hasher: inout Hasher)
//    }
//}
//
//@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
//extension Image {
//
//    public func interpolation(_ interpolation: Image.Interpolation) -> Image
//
//    public func antialiased(_ isAntialiased: Bool) -> Image
//}
//
//@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
//extension Image {
//
//    /// Creates a labeled image based on a `CGImage`, usable as content for
//    /// controls.
//    ///
//    /// - Parameters:
//    ///   - cgImage: the base graphical image
//    ///   - scale: the scale factor the image is intended for
//    ///     (e.g. 1.0, 2.0, 3.0)
//    ///   - orientation: the orientation of the image
//    ///   - label: The label associated with the image. The label is used for
//    ///     things like accessibility.
//    public init(_ cgImage: CGImage, scale: CGFloat, orientation: Image.Orientation = .up, label: Text)
//
//    /// Creates an unlabeled, decorative image based on a `CGImage`.
//    ///
//    /// This image is ignored for accessibility purposes.
//    ///
//    /// - Parameters:
//    ///   - cgImage: the base graphical image
//    ///   - scale: the scale factor the image is intended for
//    ///     (e.g. 1.0, 2.0, 3.0)
//    ///   - orientation: the orientation of the image
//    public init(decorative cgImage: CGImage, scale: CGFloat, orientation: Image.Orientation = .up)
//}
//
//@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
//@available(OSX, unavailable)
//extension Image {
//
//    public init(uiImage: UIImage)
//}
//
//@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
//extension Image {
//
//    public enum ResizingMode {
//
//        case tile
//
//        case stretch
//
//        /// Returns a Boolean value indicating whether two values are equal.
//        ///
//        /// Equality is the inverse of inequality. For any values `a` and `b`,
//        /// `a == b` implies that `a != b` is `false`.
//        ///
//        /// - Parameters:
//        ///   - lhs: A value to compare.
//        ///   - rhs: Another value to compare.
//        public static func == (a: Image.ResizingMode, b: Image.ResizingMode) -> Bool
//
//        /// The hash value.
//        ///
//        /// Hash values are not guaranteed to be equal across different executions of
//        /// your program. Do not save hash values to use during a future execution.
//        ///
//        /// - Important: `hashValue` is deprecated as a `Hashable` requirement. To
//        ///   conform to `Hashable`, implement the `hash(into:)` requirement instead.
//        public var hashValue: Int { get }
//
//        /// Hashes the essential components of this value by feeding them into the
//        /// given hasher.
//        ///
//        /// Implement this method to conform to the `Hashable` protocol. The
//        /// components used for hashing must be the same as the components compared
//        /// in your type's `==` operator implementation. Call `hasher.combine(_:)`
//        /// with each of these components.
//        ///
//        /// - Important: Never call `finalize()` on `hasher`. Doing so may become a
//        ///   compile-time error in the future.
//        ///
//        /// - Parameter hasher: The hasher to use when combining the components
//        ///   of this instance.
//        public func hash(into hasher: inout Hasher)
//    }
//
//    public func resizable(capInsets: EdgeInsets = EdgeInsets(), resizingMode: Image.ResizingMode = .stretch) -> Image
//}
//
//@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
//extension Image.Orientation : RawRepresentable {
//}
//
//@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
//extension Image.TemplateRenderingMode : Equatable {
//}
//
//@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
//extension Image.TemplateRenderingMode : Hashable {
//}
//
//@available(iOS 13.0, tvOS 13.0, watchOS 6.0, OSX 11.0, *)
//extension Image.Scale : Equatable {
//}
//
//@available(iOS 13.0, tvOS 13.0, watchOS 6.0, OSX 11.0, *)
//extension Image.Scale : Hashable {
//}
//
//@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
//extension Image.Interpolation : Equatable {
//}
//
//@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
//extension Image.Interpolation : Hashable {
//}
//
//@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
//extension Image.ResizingMode : Equatable {
//}
//
//@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
//extension Image.ResizingMode : Hashable {
//}
//
///// A shape style that fills a shape by repeating a region of an image.
//@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
//@frozen public struct ImagePaint : ShapeStyle {
//
//    /// The image to be drawn.
//    public var image: Image
//
//    /// A unit-space rectangle defining how much of the source image to draw.
//    ///
//    /// The results are undefined if this rectangle selects areas outside the
//    /// `[0, 1]` range in either axis.
//    public var sourceRect: CGRect
//
//    /// A scale factor applied to the image while being drawn.
//    public var scale: CGFloat
//
//    /// Creates a shape-filling shape style.
//    ///
//    /// - Parameters:
//    ///   - image: The image to be drawn.
//    ///   - sourceRect: A unit-space rectangle defining how much of the source
//    ///     image to draw. The results are undefined if `sourceRect` selects
//    ///     areas outside the `[0, 1]` range in either axis.
//    ///   - scale: A scale factor applied to the image during rendering.
//    public init(image: Image, sourceRect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1), scale: CGFloat = 1)
//}
//
///// Provides functionality for importing files.
/////
///// An `ImportFilesAction` should be obtained from the environment,
///// and can be used to import either a single file, or multiple files
///// via a standard system dialog.
//@available(iOS 14.0, OSX 11.0, *)
//@available(tvOS, unavailable)
//@available(watchOS, unavailable)
//public struct ImportFilesAction {
//
//    /// Requests a system prompt for allowing the user to choose a single file
//    /// for importing.
//    ///
//    /// - Parameters:
//    ///   - supportedContentTypes: The list of supported content types
//    ///     which can be imported.
//    ///   - completion: A handler which will be invoked
//    ///     when the import has finished.
//    ///   - result: An optional Result indicating whether the import operation
//    ///     succeeded or failed. The value will be `nil` if the import process
//    ///     was cancelled by the user.
//    public func callAsFunction(singleOfType supportedContentTypes: [UTType], completion: @escaping (Result<URL, Error>?) -> Void)
//
//    /// Requests a system prompt for allowing the user to choose multiple files
//    /// for importing.
//    ///
//    /// - Parameters:
//    ///   - supportedContentTypes: The list of supported content types
//    ///     which can be imported.
//    ///   - completion: A handler which will be invoked
//    ///     when the import has finished.
//    ///   - result: An optional Result indicating whether the import operation
//    ///     succeeded or failed. The value will be `nil` if the import process
//    ///     was cancelled by the user.
//    public func callAsFunction(multipleOfType supportedContentTypes: [UTType], completion: @escaping (Result<[URL], Error>?) -> Void)
//}
//
///// Defines the implementation of all `IndexView` instances within a view
///// hierarchy.
/////
///// To configure the current `IndexViewStyle` for a view hierarchy, use the
///// `.indexViewStyle()` modifier.
//@available(iOS 14.0, tvOS 14.0, *)
//@available(OSX, unavailable)
//@available(watchOS, unavailable)
//public protocol IndexViewStyle {
//}
//
///// The instance that describes the behavior and appearance of an inset grouped list.

/// A view that displays a non-environment-dependent image, on demand, from a remote
/// url.
///
/// A ``RemoteImage`` is a late-binding token, which means that its actual value is
/// only resolved when it's about to be used in a given environment.
///
/// ``RemoteImage`` also makes use of NSCache to cache the resulting image data, so
/// images dont need to be reloaded.
public struct RemoteImage<Placeholder, Result>: View where Placeholder: View, Result: View {

    /// A function you can use to create a placeholder users will see before the image is actually loaded.
    public let placeholder: Placeholder

    /// A function you can use to display the remote image.
    public let result: (Image) -> Result

    /// Used for telling the SwiftUI view to redraw itself
    /// once the image data is fetched.
    @Binding var redraw: Bool

    /// An ObservableObject that is used to be notified when the image data is available.
    @ObservedObject private var remoteImageModel: RemoteImageModel

    public var body: some View {

        VStack {
            if let remoteImage = self.remoteImageModel.image {

                result(Image(uiImage: remoteImage))
                    .onAppear {
                        self.redraw.toggle()
                    }

            } else {

                self.placeholder
                    .onAppear {
                        self.redraw.toggle()
                    }

            }
        }
            // So that the transition between the placeholder content and the actual image is smooth.
            .animation(.spring())

    }

}

extension RemoteImage where Placeholder: View {

    /// Generates a View that retrieves image data from a remote URL
    /// (usually decoded from JSON), that automatically changes across updates;
    /// and caches it.
    ///
    /// It's important that `result` makes use of the escaping closure to display the image,
    /// or else anything will be displayed. If a problem occurs while retrieving the data, an
    /// error message will be provided. You should log that and maybe show a simple message to the user.
    ///
    /// - Parameters:
    ///     - from: The ``Account``'s static avatar url ``CachedRemoteImage`` uses to retrieve the data.
    ///     - placeholder: The view builder that generates the placeholder to be shown until the avatar
    ///       data is retrieved.
    ///     - error: An optional string of the error that occurred while fetching the image data.
    ///     - result: A function you can use to display the resulting image.
    public init(from urlString: String?, redraw: Binding<Bool>, @ViewBuilder placeholder: () -> Placeholder?,
                error: String? = nil, @ViewBuilder result: @escaping (Image) -> Result) {
        self.remoteImageModel = RemoteImageModel(urlString)

        // swiftlint:disable:next force_cast
        self.placeholder = placeholder() ?? EmptyView() as! Placeholder
        self.result = result
        _redraw = redraw
    }

}

struct RemoteImage_Previews: PreviewProvider {

    // swiftlint:disable:next line_length
    static let url = "https://files.mastodon.social/cache/media_attachments/files/104/496/498/501/770/612/original/b9c7a301dd755f73.jpeg"

    @State static var redraw: Bool = false

    static var previews: some View {

        RemoteImage(
            from: url,
            redraw: self.$redraw,
            placeholder: {
                Image("sotogrande")
                    .resizable()
                    .redacted(reason: .placeholder)
            },
            result: { image in
                image
                    .resizable()
            }
        )

    }

}
