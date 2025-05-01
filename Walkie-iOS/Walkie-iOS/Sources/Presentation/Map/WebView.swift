//
//  WalkieWebView.swift
//  Walkie-iOS
//
//  Created by ahra on 3/28/25.
//

import SwiftUI

@preconcurrency import WebKit

class ContentController: NSObject, WKScriptMessageHandler {
    
    private weak var viewModel: MapViewModel?
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
    }
    
    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        print("😬😬receive from web😬😬")
        guard message.name == "iOSBridge" else { return }
        print("post Message : \(message.body)")
        
        guard let body = message.body as? [String: Any],
            let typeString = body["type"] as? String,
            let type = WebMessageType(rawValue: typeString) else {
            print("❌ Invalid message type")
            return
        }
        
        viewModel?.handleWebMessage(type)
    }
}

struct WebView: UIViewRepresentable {
    
    let request: URLRequest
    let viewModel: MapViewModel
    var webView: WKWebView?
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        contentController.add(ContentController(viewModel: viewModel), name: "iOSBridge")
        config.userContentController = contentController
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        config.websiteDataStore = .default()
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.isInspectable = true
        webView.load(request)
        
        return webView
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
