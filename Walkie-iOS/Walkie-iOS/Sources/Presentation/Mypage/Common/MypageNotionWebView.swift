//
//  MypageNotionWebView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/6/25.
//

import WebKit
import SwiftUI

struct MypageNotionWebView: UIViewRepresentable {
    let url: URL?

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        if let url = url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        return
    }
}

enum MypageNotionWebViewURL: String {
    case privacy = "https://rb.gy/wlxmbg"
    case service = "https://rb.gy/qwcilh"
    case questions = "https://rb.gy/1c7mk5"
    case notice = "https://rb.gy/rjmo3k"
    
    var url: URL? {
        return URL(string: self.rawValue)
    }
}
