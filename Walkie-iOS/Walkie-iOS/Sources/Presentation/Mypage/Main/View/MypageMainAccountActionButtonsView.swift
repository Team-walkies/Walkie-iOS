//
//  MypageMainAccountActionButtonsView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/1/25.
//

import SwiftUI

import WalkieCommon

struct MypageMainAccountActionButtonsView: View {
    
    @ObservedObject var viewModel: MypageMainViewModel
    @EnvironmentObject var appCoordinator: AppCoordinator

    var body: some View {
        HStack(spacing: 12) {
            Button(
            action: {
                appCoordinator.buildAlert(
                    title: "로그아웃",
                    content: "앱에서 로그아웃할까요?",
                    style: .error,
                    button: .twobutton,
                    cancelButtonAction: {},
                    checkButtonAction: {
                        viewModel.action(.logout)
                    },
                    checkButtonTitle: "로그아웃",
                    cancelButtonTitle: "뒤로가기"
                )
            }, label: {
                Text("로그아웃")
                    .font(.B2)
                    .foregroundStyle(WalkieCommonAsset.gray400.swiftUIColor)
            })
            
            Rectangle()
                .frame(width: 1, height: 16)
                .foregroundStyle(WalkieCommonAsset.gray300.swiftUIColor)
            
            Button(action: {
                appCoordinator.push(AppScene.withdraw)
            }, label: {
                Text("탈퇴하기")
                    .font(.B2)
                    .foregroundStyle(WalkieCommonAsset.gray400.swiftUIColor)
            })
        }
        .frame(alignment: .center)
    }
}
