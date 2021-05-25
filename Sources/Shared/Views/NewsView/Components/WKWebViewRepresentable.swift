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
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(HTMLString, baseURL: nil)

    }
    
}
