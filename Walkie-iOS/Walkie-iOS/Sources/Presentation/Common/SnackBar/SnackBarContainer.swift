//
//  SnackBarContainer.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 2/12/25.
//

import SwiftUI

struct SnackBarContainer: View {
    @ObservedObject var snackBarManager = SnackBarManager.shared

    var body: some View {
        VStack {
            Spacer()
            if snackBarManager.isShowing {
                SnackBarView(
                    highlightedMessage: snackBarManager.highlightedMessage,
                    message: snackBarManager.message,
                    buttonTitle: snackBarManager.buttonTitle,
                    buttonAction: {
                        snackBarManager.buttonAction?()
                        snackBarManager.hideSnackBar()
                    },
                    state: snackBarManager.state
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 106)
                .animation(.easeInOut, value: snackBarManager.isShowing)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea(.all, edges: .bottom)
        .zIndex(1)
    }
}
