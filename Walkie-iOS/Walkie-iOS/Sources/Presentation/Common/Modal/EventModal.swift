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
    let style: ModalStyleType
    let button: ModalButtonType
    let cancelButtonAction: () -> Void
    let checkButtonAction: () -> Void
    var checkButtonTitle: String = "보러가기"
    var cancelButtonTitle: String = "닫기"
    let deadline: String
    
    private var dDay: Int {
        guard let deadlineDate = Date.stringToDate(string: deadline) else {
            return 0
        }
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfDeadline = calendar.startOfDay(for: deadlineDate)
        let comps = calendar.dateComponents(
            [.day],
            from: startOfToday,
            to: startOfDeadline
        )
        return max(comps.day ?? 0, 0)
    }
    
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
                
                HStack(
                    spacing: 4
                ) {
                    Text("이벤트 종료까지")
                        .font(.B2)
                        .foregroundColor(WalkieCommonAsset.blue400.swiftUIColor)
                    
                    Text("D-\(dDay)")
                        .font(.H6)
                        .foregroundColor(WalkieCommonAsset.blue400.swiftUIColor)
                        .padding(.horizontal, 8)
                        .background(WalkieCommonAsset.blue50.swiftUIColor)
                        .cornerRadius(4, corners: .allCorners)
                }
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
