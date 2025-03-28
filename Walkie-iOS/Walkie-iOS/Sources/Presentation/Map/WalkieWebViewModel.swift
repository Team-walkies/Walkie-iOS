//
//  WalkieWebViewModel.swift
//  Walkie-iOS
//
//  Created by ahra on 3/28/25.
//

import Foundation

import Combine
import WebKit

class WalkieWebViewModel: ObservableObject {
    
    @Published var shouldLoadWebView = false
    @Published var webViewURL: URL?
    @Published var receivedMessage: String = "아직 메시지 없음"
    
    var webView: WKWebView?
    private var coordinator: WebView.Coordinator?
    
    func getCoordinator(for webView: WebView) -> WebView.Coordinator {
        if coordinator == nil {
            coordinator = WebView.Coordinator(webView)
        }
        return coordinator!
    }
    
//    func loadLocalHTML() {
//        if let url = Bundle.main.url(forResource: "test", withExtension: "html") {
//            DispatchQueue.main.async { [weak self] in
//                self?.webViewURL = url
//                self?.shouldLoadWebView = true
//            }
//        } else {
//            print("test.html 파일을 찾을 수 없음")
//        }
//    }
    
    func loadLocalHTML() {
        let url = URL(string: "http://127.0.0.1:8000/test.html")!
        print(url)
        DispatchQueue.main.async { [weak self] in
            self?.webViewURL = url
            self?.shouldLoadWebView = true
        }
    }
    
    func sendMessageToWeb(completionHandler: @escaping (Any?, Error?) -> Void) {
        print("😳😳send to web😳😳")
        print("webView 상태: \(String(describing: webView))")
        let script = "mobileBridge('i am ahra')"
        webView?.evaluateJavaScript(script) { (result, error) in
            if let error = error {
                print("Error calling JS function: \(error)")
                completionHandler(nil, error)
            } else if let result = result {
                print("Received result from JS function: \(result)")
                completionHandler(result, nil)
            }
        }
    }
    
    func receiveMessageFromWeb(message: String) {
        print("😬😬receive from web😬😬")
        print("웹에서 받은 메시지: \(message)")
        self.receivedMessage = message
    }
}
