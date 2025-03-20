//
//  MypageMyInformationView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/1/25.
//

import SwiftUI

import WalkieCommon

struct MypageMyInformationView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: MypageMainViewModel
    
    var body: some View {
        NavigationBar(
            title: "내 정보",
            showBackButton: true,
            backButtonAction: {
                dismiss()
            }
        )
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: 0) {
                    Text("프로필 공개 설정")
                        .font(.H4)
                        .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
                        .padding(.bottom, 12)
                    SwitchOptionItemView(
                        title: "프로필 공개",
                        subtitle: "내 후기가 다른 사람에게 공개돼요",
                        isOn: viewModel.myInformationState.isPublic,
                        toggle: { viewModel.action(.toggleMyInformationIsPublic) }
                    )                }
                .padding(.top, 12)
                .padding(.horizontal, 16)
        }
    }
}

#Preview {
    MypageMyInformationView(viewModel: MypageMainViewModel())
}
