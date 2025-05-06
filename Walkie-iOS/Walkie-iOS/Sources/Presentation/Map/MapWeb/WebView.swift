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
        
        guard let body = message.body as? [String: Any] else {
            print("❌ message body is not a dictionary")
            return
        }

        let typeString = body["type"] as? String
        let payload = body["payload"] as? [String: Any]

        if let typeString, let type = WebMessageType(rawValue: typeString) {
            let message = WebMessage(type: type, payload: payload)
            print(message)
            viewModel?.handleWebMessage(message)
        } else {
            print("❌ Unknown or missing type: \(String(describing: typeString))")
        }
    }
}

struct WebView: UIViewRepresentable {
    
    let request: URLRequest
    let viewModel: MapViewModel
    
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
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.scrollView.keyboardDismissMode = .interactive
        
        context.coordinator.webView = webView
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
    
    func makeCoordinator() -> Coordinator {
        let coord = Coordinator(viewModel: viewModel)
        viewModel.sendToWeb = coord.sendToWeb(message:)
        return coord
    }
    
    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        let viewModel: MapViewModel
        var webView: WKWebView?
        
        init(viewModel: MapViewModel) {
            self.viewModel = viewModel
        }
        
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
