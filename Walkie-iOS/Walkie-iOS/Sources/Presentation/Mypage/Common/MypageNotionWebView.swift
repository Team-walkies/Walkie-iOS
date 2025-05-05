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
    case privacy = "https://zippy-cake-826.notion.site/1c2e3ac17cda80c9b4c8cc05f9812e14?pvs=4"
    case service = "https://zippy-cake-826.notion.site/1c2e3ac17cda80d68d32e75b8e72fef6?pvs=4"
    case questions = "https://docs.google.com/forms/d/e/1FAIpQLSeYLEpG80S2RbgeWpjHL3jpZ-pys3I0LR0MxjwpChrKOpf_zA/viewform?usp=dialog"
    
    var url: URL? {
        return URL(string: self.rawValue)
    }
}
