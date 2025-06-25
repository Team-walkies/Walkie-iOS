//
//  EventModal.swift
//  Walkie-iOS
//
//  Created by 고아라 on 6/25/25.
//

import SwiftUI

import WalkieCommon

struct EventModal: View {
    
    @Environment(\.screenHeight) var screenHeight
    
    // MARK: - Properties
    
    let title: String
    let content: String
    let style: ModalStyleType
    let button: ModalButtonType
    let cancelButtonAction: () -> Void
    let checkButtonAction: () -> Void
    var checkButtonTitle: String = "보러가기"
    var cancelButtonTitle: String = "닫기"
    
    // MARK: - Body
    
    var body: some View {
        VStack(
            alignment: .center,
            spacing: 20
        ) {
            VStack(
                alignment: .center,
                spacing: 4
            ) {
                let imgHeight = screenHeight * 0.25
                let imgWidth = imgHeight * 1.18
                Image(.imgGiftEgg)
                    .resizable()
                    .scaledToFit()
                    .frame(width: imgWidth, height: imgHeight)
                
                Text(title)
                    .font(.H4)
                    .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                    .multilineTextAlignment(.center)
                
                Text(content)
                    .font(.B2)
                    .foregroundColor(WalkieCommonAsset.blue400.swiftUIColor)
                    .multilineTextAlignment(.center)
            }
            
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
                .padding(.horizontal, 8)
                .padding(.bottom, 16)
            }
        }
        .background(.white)
        .cornerRadius(24, corners: .allCorners)
    }
}
