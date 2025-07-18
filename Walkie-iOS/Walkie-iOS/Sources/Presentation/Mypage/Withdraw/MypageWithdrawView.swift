//
//  MypageWithdrawView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/1/25.
//

import SwiftUI
import WalkieCommon

struct MypageWithdrawView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: MypageWithdrawViewModel
    @State var isChecked: Bool = false
    
    var body: some View {
        VStack {
            NavigationBar(
                title: "탈퇴하기",
                showBackButton: true
            ).padding(.bottom, 40)
            VStack(alignment: .center, spacing: 0) {
                Text("\(viewModel.state.nickname)님이 떠나시다니,\n너무 아쉬워요")
                    .font(.H3)
                    .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 32)
                VStack(alignment: .leading, spacing: 4) {
                    Text("모든 데이터가 삭제돼요")
                        .font(.H6)
                        .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
                    Text("스팟 기록, 알, 캐릭터 등 모든 정보가 즉시 삭제돼요.\n모든 데이터는 복구할 수 없어요.")
                        .font(.B2)
                        .foregroundStyle(WalkieCommonAsset.gray500.swiftUIColor)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(WalkieCommonAsset.gray50.swiftUIColor)
                .cornerRadius(12, corners: .allCorners)
                .padding(.bottom, 8)
                .padding(.horizontal, 16)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("스팟 리뷰는 직접 삭제해야 해요")
                        .font(.H6)
                        .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
                    Text("워키를 탈퇴해도 작성한 리뷰는 없어지지 않아요.\n기록이 남는 걸 원치않는다면 확인하고 삭제해 주세요.")
                        .font(.B2)
                        .foregroundStyle(WalkieCommonAsset.gray500.swiftUIColor)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(WalkieCommonAsset.gray50.swiftUIColor)
                .cornerRadius(12, corners: .allCorners)
                .padding(.bottom, 32)
                .padding(.horizontal, 16)
                
                CheckboxWithLabel(isChecked: $isChecked, text: "안내사항을 모두 확인했으며, 이에 동의합니다")
                Spacer()
                CTAButton(
                    title: "탈퇴하기",
                    style: .danger,
                    size: .large,
                    isEnabled: isChecked,
                    buttonAction: {
                        viewModel.action(.willWithdraw)
                    }
                )
                .padding(.bottom, 38)
            }.ignoresSafeArea(.all)
        }
    }
}
