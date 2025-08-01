//
//  MypageMyInformationView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/1/25.
//

import SwiftUI
import WalkieCommon

struct MypageMyInformationView: View {
    
    @StateObject var viewModel: MypageMyInformationViewModel
    @Environment(\.screenWidth) private var screenWidth
    
    var body: some View {
        NavigationBar(
            title: "내 정보",
            showBackButton: true
        )
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: 0) {
                    Text("프로필 설정")
                        .font(.H4)
                        .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
                        .padding(.bottom, 12)
                    ChangeNicknameItemView(
                        nickname: viewModel.state.nickname,
                        onTap: {
                            viewModel.action(.didTapChangeNicknameButton)
                        }
                    )
                    .padding(.bottom, 8)
                    SwitchOptionItemView(
                        title: "프로필 공개",
                        subtitle: "내 후기가 다른 사람에게 공개돼요",
                        isOn: viewModel.state.isPublic,
                        toggle: { viewModel.action(.togglePublicSetting) }
                    )
                }
                .padding(.top, 12)
                .padding(.horizontal, 16)
        }
    }
}

private struct ChangeNicknameItemView: View {
    
    let nickname: String
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                Text("닉네임 변경")
                    .font(.H6)
                    .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer(minLength: 0)
                Text(nickname)
                    .font(.C1)
                    .foregroundStyle(WalkieCommonAsset.gray500.swiftUIColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Spacer(minLength: 0)
            Image(.icChevronRight)
                .resizable()
                .frame(width: 24, height: 24)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(WalkieCommonAsset.gray50.swiftUIColor)
        .clipShape(.rect(cornerRadius: 12))
        .onTapGesture {
            onTap()
        }
    }
}
