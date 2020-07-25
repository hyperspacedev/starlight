//
//  AsyncImageViewModel.swift
//  Codename Starlight
//
//  Created by Alejandro Modroño Vara on 11/07/2020.
//

import Foundation
import SwiftUI

/// An ``ObservableObject`` that computes and retrieves image data on demand from the fediverse,
/// using Mastodon's API endpoints.
public class RemoteImageModel: ObservableObject {

    #if os(iOS)
    /// The image data displayed as an UIImage.
    @Published public var image: UIImage?
    #else
    /// The image data displayed as a NSImage.
    @Published public var image: NSImage?
    #endif

    @Published public var error: String? {
        didSet {
            print(self.error as Any)
        }
    }

    /// The url from where the data is downloaded.
    public var urlString: String?

    public var imageCache = ImageCache.getImageCache()

    public init(_ urlString: String?) {
        self.urlString = urlString
        loadImage()
    }

    func loadImage() {
        if loadImageFromCache() { return }

        loadImageFromUrl()
    }

    func loadImageFromCache() -> Bool {
        guard let urlString = urlString else {
            return false
        }

        guard let cacheImage = imageCache.get(forKey: urlString) else {
            return false
        }

        image = cacheImage
        return true
    }

    func loadImageFromUrl() {
        guard let urlString = urlString else {
            return
        }

        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url, completionHandler: getImageFromResponse(data:response:error:))
        task.resume()
    }

    func getImageFromResponse(data: Data?, response: URLResponse?, error: Error?) {
        guard error == nil else {
            self.error = "\(error!)"
            return
        }
        guard let data = data else {
            self.error = "No data found"
            return
        }

        DispatchQueue.main.async {
            #if os(iOS)
            guard let loadedImage = UIImage(data: data) else {
                return
            }
            #else
            guard let loadedImage = NSImage(data: data) else {
                return
            }
            #endif

            self.imageCache.set(forKey: self.urlString!, image: loadedImage)
            self.image = loadedImage
        }
    }
}

public class ImageCache {
    #if os(iOS)
    var cache = NSCache<NSString, UIImage>()

    func get(forKey: String) -> UIImage? {
        return cache.object(forKey: NSString(string: forKey))
    }

    func set(forKey: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: forKey))
    }
    #else
    var cache = NSCache<NSString, NSImage>()

    func get(forKey: String) -> NSImage? {
        return cache.object(forKey: NSString(string: forKey))
    }

    func set(forKey: String, image: NSImage) {
        cache.setObject(image, forKey: NSString(string: forKey))
    }
    #endif

}

extension ImageCache {
    private static var imageCache = ImageCache()
    static func getImageCache() -> ImageCache {
        return imageCache
    }
}
