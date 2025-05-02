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
}

struct WebMessage {
    let type: WebMessageType
    let payload: [String: Any]?
}
