//
//  ToastContainer.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 2/12/25.
//

import SwiftUI

struct ToastContainer: View {
    @ObservedObject var toastManager = ToastManager.shared

    var body: some View {
        VStack {
            Spacer()
            if toastManager.isShowing {
                ToastView(message: toastManager.message, icon: toastManager.icon)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 40)
                    .animation(.easeInOut, value: toastManager.isShowing)
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .frame(alignment: .bottom)
        .zIndex(.infinity)
        .allowsHitTesting(false)
    }
}
