//
//  ToastManager.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 2/12/25.
//

import SwiftUI

class ToastManager: ObservableObject {
    static let shared = ToastManager()
    
    @Published private(set) var message: String = ""
    @Published private(set) var icon: UIImage?
    @Published private(set) var isShowing = false
    
    private var dismissWorkItem: DispatchWorkItem?

    private init() {}

    func showToast(_ message: String, icon: UIImage? = nil, duration: TimeInterval = 2.5) {
        self.message = message
        self.icon = icon

        // 기존 타이머가 실행 중이면 취소합니다
        dismissWorkItem?.cancel()

        withAnimation(.easeIn(duration: 0.1)) { isShowing = true }

        // 새로운 타이머를 설정합니다
        let workItem = DispatchWorkItem {
            withAnimation(.easeOut(duration: 0.1)) { self.isShowing = false }
        }
        
        self.dismissWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: workItem)
    }
}
