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
}

struct WebMessage {
    let type: WebMessageType
    let payload: [String: Any]?
}
