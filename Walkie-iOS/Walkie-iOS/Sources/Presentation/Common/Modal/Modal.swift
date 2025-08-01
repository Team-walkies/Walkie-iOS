//
//  Modal.swift
//  Walkie-iOS
//
//  Created by ahra on 2/10/25.
//

import SwiftUI

import WalkieCommon

struct Modal: View {
    
    // MARK: - Properties
    
    let title: String
    let highlightedContent: String?
    let highlightedColor: Color?
    let content: String
    let style: ModalStyleType
    let button: ModalButtonType
    let cancelButtonAction: () -> Void
    let checkButtonAction: () -> Void
    var checkButtonTitle: String = "확인"
    var cancelButtonTitle: String = "취소"
    
    // MARK: - Body
    
    var body: some View {
        VStack(
            alignment: .center,
            spacing: 0
        ) {
            Text(title)
                .font(.H4)
                .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                .padding(.horizontal, 16)
                .padding(.bottom, 4)
                .multilineTextAlignment(.center)
            if let highlightedContent, highlightedColor != nil{
                Text(highlightedContent)
                    .font(.B2)
                    .foregroundColor(highlightedColor)
                    .multilineTextAlignment(.center)
            }
            Text(content)
                .font(.B2)
                .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
                .padding(.horizontal, 16)
                .padding(.bottom, 20)   
                .multilineTextAlignment(
                    content.contains("백그라운드 동작") ? .leading : .center
                )
            
            switch button {
            case .onebutton:
                CTAButton(
                    title: checkButtonTitle,
                    style: style == .primary ? .primary : .danger,
                    size: .modal,
                    isEnabled: true) {
                        checkButtonAction()
                    }
            case .twobutton:
                HStack(
                    spacing: -8
                ) {
                    CTAButton(
                        title: cancelButtonTitle,
                        style: .modal,
                        size: .modal,
                        isEnabled: false) {
                            cancelButtonAction()
                        }
                    CTAButton(
                        title: checkButtonTitle,
                        style: style == .primary ? .primary : .danger,
                        size: .modal,
                        isEnabled: true) {
                            checkButtonAction()
                    }
                }
            }
        }
        .padding(.vertical, 16)
        .background(.white)
        .cornerRadius(20, corners: .allCorners)
    }
}
