//
//  WebView.swift
//  Hyperspace
//
//  Created by Alex Modroño Vara on 2/1/21.
//

import Foundation
import WebKit
import SwiftUI

struct WebView: UIViewRepresentable {

    var content: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Self.Context) -> WKWebView {

        let index = Bundle.main.url(forResource: "index", withExtension: "html")!
        
        let indexTemplateUrlRequest = URLRequest(url: index)
        
        let script = """
        document.getElementById('content').innerHTML = `<br>\(content)`;

        var elements = document.getElementsByClassName('vfbp-form');
        while(elements.length > 0) {
            elements[0].parentNode.removeChild(elements[0]);
        }

        let articleContentImages = document.getElementsByTagName("img");
        for(let i = 0; i < articleContentImages.length; i++) {

            articleContentImages[i].removeAttribute("width",0);
            articleContentImages[i].removeAttribute("height",0);

            articleContentImages[i].style.height = "auto";
            articleContentImages[i].style.width = "\(UIScreen.main.bounds.width - 50)px";

            articleContentImages[i].src = articleContentImages[i].src.split("?")[0];

        }
        """
        let userScript = WKUserScript(source: script, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        
        let userContentController = WKUserContentController()
        userContentController.addUserScript(userScript)
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.uiDelegate = context.coordinator
        webView.load(indexTemplateUrlRequest)

        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Self.Context) {
    }

    class Coordinator : NSObject, WKUIDelegate, WKNavigationDelegate {

        var parent: WebView

        init(_ webView: WebView) {
            self.parent = webView
        }

        func webView(_ webView: WKWebView,
                     createWebViewWith configuration: WKWebViewConfiguration,
                     for navigationAction: WKNavigationAction,
            windowFeatures: WKWindowFeatures) -> WKWebView? {
                if navigationAction.targetFrame == nil {
                    let url = navigationAction.request.url
                    if url!.description.lowercased().range(of: "http://") != nil || url!.description.lowercased().range(of: "https://") != nil || url!.description.lowercased().range(of: "mailto:") != nil ||
                        url!.description.lowercased().range(of: "sureservice") != nil {
                        openUrl(url!)
                    }
                }
                return nil
        }

    }

}
