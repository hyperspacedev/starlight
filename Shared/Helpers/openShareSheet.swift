//
//  openShareSheet.swift
//  Codename Starlight
//
//  Created by Alejandro Modroño Vara on 29/7/20.
//

#if os(iOS)
import Foundation
import UIKit

func openShareSheet(content: String) {
    let activityView = UIActivityViewController(activityItems: [content], applicationActivities: nil)

    UIApplication.shared.windows.first?.rootViewController?.present(activityView, animated: true, completion: nil)

    if UIDevice.current.userInterfaceIdiom == .pad {
        activityView.popoverPresentationController?.sourceView = UIApplication.shared.windows.first
        activityView.popoverPresentationController?.sourceRect = CGRect(
            x: UIScreen.main.bounds.width / 2.1,
            y: UIScreen.main.bounds.height / 2.3,
            width: 200, height: 200)
    }
}

func openShareSheet(url: URL) {
    let activityView = UIActivityViewController(activityItems: [url], applicationActivities: nil)

    UIApplication.shared.windows.first?.rootViewController?.present(activityView, animated: true, completion: nil)

    if UIDevice.current.userInterfaceIdiom == .pad {
        activityView.popoverPresentationController?.sourceView = UIApplication.shared.windows.first
        activityView.popoverPresentationController?.sourceRect = CGRect(
            x: UIScreen.main.bounds.width / 2.1,
            y: UIScreen.main.bounds.height / 2.3,
            width: 200, height: 200)
    }
}
#endif
