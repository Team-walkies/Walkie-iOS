//
//  SnackBarView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 2/12/25.
//

import SwiftUI

import WalkieCommon

struct SnackBarView: View {
    
    let highlightedMessage: String
    let message: String
    let buttonTitle: String?
    let buttonAction: (() -> Void)?
    let state: SnackBarState
    
    var body: some View {
        HStack(alignment: .center) {
            HighlightTextAttribute(
                text: highlightedMessage + message,
                textColor: WalkieCommonAsset.gray200.swiftUIColor,
                font: .B2,
                highlightText: highlightedMessage,
                highlightColor: .white,
                highlightFont: .H6
            )
            Spacer()
            if state != .noButton, let buttonTitle, let buttonAction {
                Button(action: {
                    buttonAction()
                    SnackBarManager.shared.hideSnackBar()
                }, label: {
                    Text(buttonTitle)
                        .font(.C1)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                })
                .frame(height: 32)
                .background(state.buttonColor)
                .cornerRadius(8, corners: .allCorners)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 56)
        .background(WalkieCommonAsset.gray900.swiftUIColor.opacity(0.7))
        .cornerRadius(12, corners: .allCorners)
    }
}
