//
//  WalkieWebView.swift
//  Walkie-iOS
//
//  Created by ahra on 3/28/25.
//

import SwiftUI

import WebKit

struct WebView: UIViewRepresentable {
    
    let url: URL?
    let viewModel: WalkieWebViewModel
    
//    func makeUIView(context: Context) -> WKWebView {
//        let webView: WKWebView
//        if let existingWebView = viewModel.webView {
//            // 이미 생성된 webView가 있다면 그것을 재사용
//            webView = existingWebView
//        } else {
//            // 새로운 webView를 생성
//            webView = WKWebView()
//            webView.navigationDelegate = context.coordinator
//            webView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
//            webView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
//            let contentController = webView.configuration.userContentController
//            contentController.add(context.coordinator, name: "iOSBridge")
//            viewModel.webView = webView
//        }
//        print("💁🏻💁🏻💁🏻💁🏻")
//        print(webView)
//        
////        if let url = url {
////            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
////        }
//        
//        if let url = viewModel.webViewURL {
//            webView.load(URLRequest(url: url)) // HTTP URL 로드
//        }
//        print("💁🏻💁🏻💁🏻💁🏻")
//        print(url)
//        
//        return webView
//    }
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        
        let contentController = webView.configuration.userContentController
        contentController.add(context.coordinator, name: "iOSBridge")
        viewModel.webView = webView
        
        if let url = viewModel.webViewURL {
            print("✅ 로드할 URL: \(url.absoluteString)")
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
            webView.load(request)
        }
        print("WalkieWebView 초기화, webView: \(webView)")
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = viewModel.webViewURL, uiView.url != url {
               print("🔄 WebView 업데이트: 새로운 URL 로드 (\(url))")
               uiView.load(URLRequest(url: url))
           }
           print("updateUIView 호출, webView 프레임: \(uiView.frame)")
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func userContentController(
            _ userContentController: WKUserContentController,
            didReceive message: WKScriptMessage) {
                print("😬😬userContentController😬😬")
                print(message)
                if message.name == "iOSBridge", let body = message.body as? String {
                    print("웹에서 받은 메시지: \(body)")
                    parent.viewModel.receiveMessageFromWeb(message: body)
                } else {
                    print("😬😬😬😬")
                }
            }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("웹뷰 로드 완료")
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("❌ didFailProvisionalNavigation 발생: \(error.localizedDescription)")
            
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("❌ didFail 발생: \(error.localizedDescription)")
        }
    }
}
