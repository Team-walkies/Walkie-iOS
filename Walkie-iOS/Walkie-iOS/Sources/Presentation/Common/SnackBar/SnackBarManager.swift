//
//  SnackBarManager.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 2/12/25.
//

import SwiftUI

class SnackBarManager: ObservableObject {
    static let shared = SnackBarManager()
    
    @Published private(set) var state: SnackBarState = .noButton
    
    @Published private(set) var highlightedMessage: String = ""
    @Published private(set) var message: String = ""
    @Published private(set) var buttonTitle: String?
    @Published private(set) var buttonAction: (() -> Void)?
    @Published private(set) var isShowing = false
    
    private init() {}
    
    func showSnackBar(
        highlightedMessage: String,
        message: String,
        state: SnackBarState,
        buttonTitle: String?,
        buttonAction: (() -> Void)?) {
        self.highlightedMessage = highlightedMessage
        self.message = message
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
        updateState(state)
        withAnimation(.easeIn(duration: 0.1)) { isShowing = true }
    }
    
    func hideSnackBar() {
        withAnimation(.easeOut(duration: 0.1)) { isShowing = false }
    }
    
    func updateState(_ newState: SnackBarState) {
        self.state = newState
    }
}
