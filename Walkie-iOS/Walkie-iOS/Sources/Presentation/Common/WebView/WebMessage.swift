//
//  WebMessage.swift
//  Walkie-iOS
//
//  Created by ahra on 5/1/25.
//

enum WebMessageType: String {
    case haptic
    case startCountingSteps
    case finishWebView
    case startExplore
    case getStepsFromMobile
    case stopExplore
    case unauthorizedFromWeb
    case finishReviewModify
    case getEgg
}

struct WebMessage {
    let type: WebMessageType
    let payload: [String: Any]?
}

protocol WebMessageHandling {
    func handleWebMessage(_ message: WebMessage)
}
