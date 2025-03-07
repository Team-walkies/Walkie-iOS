//
//  Modal.swift
//  Walkie-iOS
//
//  Created by ahra on 2/10/25.
//

import SwiftUI

enum ModalStyleType {
    case primary
    case error
}

enum ModalButtonType {
    case onebutton
    case twobutton
}

struct Modal: View {
    
    // MARK: - Properties
    
    let title: String
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
                .foregroundColor(.gray700)
                .padding(.bottom, 4)
            
            Text(content)
                .font(.B2)
                .foregroundColor(.gray500)
                .padding(.bottom, 20)
            
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
                HStack(spacing: -24) {
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
        .frame(width: 280, height: 154)
        .background(.white)
        .cornerRadius(20, corners: .allCorners)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.gray100
        
        VStack {
            Modal(
                title: "제목",
                content: "내용입니다",
                style: .primary,
                button: .onebutton,
                cancelButtonAction: {},
                checkButtonAction: {print("확인눌럿음")})
            Modal(
                title: "제목",
                content: "내용입니다",
                style: .error,
                button: .onebutton,
                cancelButtonAction: {},
                checkButtonAction: {print("확인눌럿음")})
            Modal(
                title: "제목",
                content: "내용입니다",
                style: .primary,
                button: .twobutton,
                cancelButtonAction: {print("취소눌럿음")},
                checkButtonAction: { print("확인눌럿음") })
            Modal(
                title: "제목",
                content: "내용입니다",
                style: .error,
                button: .twobutton,
                cancelButtonAction: { print("취소눌럿음")},
                checkButtonAction: { print("확인눌럿음") })
        }
    }
}
