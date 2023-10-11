//
//  WKWebViewRepresentable.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/25/21.
//

import SwiftUI
import WebKit

struct WKWebViewRepresentable: UIViewRepresentable {
    typealias UIViewType = WKWebView
    var HTMLString: String
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        webView.scrollView.backgroundColor = UIColor.clear
        if UITraitCollection.current.userInterfaceStyle == .dark {
            applyColor(webView: webView, text: "white", link: Color.appSecondary.hexString)
        }
        else {
            applyColor(webView: webView, text: "black", link: Color.appPrimary.hexString)
        }
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(HTMLString, baseURL: nil)

    }

    // Function to apply text color using CSS
    func applyColor(webView: WKWebView, text: String, link: String) {
        let css = """
                var style = document.createElement('style');
                style.innerHTML = "body { color: \(text); } a { color: \(link); }";
                document.head.appendChild(style);
                """
        let userScript = WKUserScript(source: css, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        webView.configuration.userContentController.addUserScript(userScript)
    }
    
}
