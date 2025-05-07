//
//  WalkieWebView.swift
//  Walkie-iOS
//
//  Created by ahra on 3/28/25.
//

import SwiftUI

@preconcurrency import WebKit

class ContentController: NSObject, WKScriptMessageHandler {
    
    private let handlers: [WebMessageHandling]
    
    init(handlers: [WebMessageHandling]) {
        self.handlers = handlers
    }
    
    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        guard message.name == "iOSBridge" else { return }
        guard
            let body = message.body as? [String: Any],
            let typeString = body["type"] as? String,
            let type = WebMessageType(rawValue: typeString)
        else {
            print("❌ Invalid WebMessage:", message.body)
            return
        }
        
        let payload = body["payload"] as? [String: Any]
        let webMessage = WebMessage(type: type, payload: payload)
        print("💁💁💁💁")
        print(webMessage)
        handlers.forEach { $0.handleWebMessage(webMessage) }
    }
}

struct WebView: UIViewRepresentable {
    
    let request: URLRequest
    let messageHandlers: [WebMessageHandling]
    let bridgeName: String = "iOSBridge"
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        contentController.add(ContentController(handlers: messageHandlers), name: bridgeName)
        config.userContentController = contentController
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        config.websiteDataStore = .default()
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.isInspectable = true
        webView.load(request)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.scrollView.keyboardDismissMode = .interactive
        
        context.coordinator.webView = webView
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        weak var webView: WKWebView?
        
        func webView(
            _ webView: WKWebView,
            didReceive challenge: URLAuthenticationChallenge,
            completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
                completionHandler(.performDefaultHandling, nil)
            }
        
        func webView(
            _ webView: WKWebView,
            didFinish navigation: WKNavigation!) {
            print("✅ WebView didFinish")
            self.webView = webView
        }
        
        func sendToWeb(message: Int) {
            print("😳😳send to web😳😳")
            webView?.evaluateJavaScript("window.onReceiveStepsFromiOS(\(message))") { result, error in
                if let error {
                    print("Error \(error.localizedDescription)")
                    return
                }
                print("Received Data \(result ?? "")")
            }
        }
    }
}
