//
//  WalkieWebView.swift
//  Walkie-iOS
//
//  Created by ahra on 3/28/25.
//

import SwiftUI

@preconcurrency import WebKit

class ContentController: NSObject, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("😬😬receive from web😬😬")
        print(message)
        if message.name == "iOSBridge" {
            print("message name : \(message.name)")
            print("post Message : \(message.body)")
        }
    }
}

struct WebView: UIViewRepresentable {
    let request: URLRequest
    private var webView: WKWebView?
    
    init(request: URLRequest) {
        self.webView = WKWebView()
        self.request = request
        self.webView?.configuration.userContentController.add(ContentController(), name: "iOSBridge")
        self.webView?.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        self.webView?.configuration.websiteDataStore = WKWebsiteDataStore.default()
        self.webView?.isInspectable = true
    }
    
    func makeUIView(context: Context) -> WKWebView {
        webView?.navigationDelegate = context.coordinator
        webView?.uiDelegate = context.coordinator
        return webView!
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        let parent: WebView
        
        init(parent: WebView) {
            self.parent = parent
        }
        
        func webView(
            _ webView: WKWebView,
            didReceive challenge: URLAuthenticationChallenge,
            completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
                completionHandler(.performDefaultHandling, nil)
            }
    }
}

extension WebView {
    func sendToWeb() {
        print("😳😳send to web😳😳")
        webView?.evaluateJavaScript("mobileBridge('i am ahra')") { result, error in
            if let error {
                print("Error \(error.localizedDescription)")
                return
            }
            
            if result == nil {
                print("It's void function")
                return
            }
            
            print("Received Data \(result ?? "")")
        }
    }
}
