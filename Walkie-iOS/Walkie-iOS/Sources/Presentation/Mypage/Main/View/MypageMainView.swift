//
//  MypageMainView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 2/20/25.
//

import SwiftUI
struct MypageMainView: View {
    var body: some View {
        NavigationBar(
            showAlarmButton: true,
            hasAlarm: true)
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                ProfileSectionView()
                    .padding(.bottom, 20)
                
                MypageMainSettingSectionView()
                    .padding(.bottom, 8)
                
                MypageMainServiceSectionView()
                    .padding(.bottom, 8)
                
                FeedbackButtonView()
                    .padding(.bottom, 12)
                
                AccountActionButtonsView()
            }
            .frame(alignment: .top)
            .padding(.horizontal, 16)
        }
    }
}

private struct ProfileSectionView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 0) {
                Text("승빈짱짱")
                    .font(.H2)
                    .foregroundStyle(.gray700)
                Text("님")
                    .font(.H2)
                    .foregroundStyle(.gray500)
                    .padding(.trailing, 8)
                Text("초보워키")
                    .font(.B2)
                    .foregroundStyle(.blue400)
                    .padding(.horizontal, 8)
                    .frame(height: 28)
                    .background(.blue50)
                    .cornerRadius(8)
                Spacer()
            }
            
            HighlightTextAttribute(
                text: "지금까지 5개의 스팟을 탐험했어요",
                textColor: .gray500,
                font: .B1,
                highlightText: "5",
                highlightColor: .blue400,
                highlightFont: .H5)
        }
    }
}

private struct FeedbackButtonView: View {
    var body: some View {
        Button(
            action: {
                // 피드백 이동
            },
            label: {
                HStack(spacing: 0) {
                    Image(.icMyFeedback)
                        .frame(width: 36, height: 36)
                        .padding(.trailing, 8)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("앱에 대한 의견을 남겨주세요!")
                            .font(.B2)
                            .foregroundStyle(.gray700)
                        Text("더 나은 서비스를 위해 노력할게요")
                            .font(.C1)
                            .foregroundStyle(.gray500)
                    }
                    Spacer()
                    Image(.icChevronRight)
                        .frame(width: 28, height: 28)
                        .foregroundColor(.gray300)
                }
                .padding(16)
            }
        )
        .frame(height: 72)
        .background(.gray100)
        .cornerRadius(12)
    }
}

private struct AccountActionButtonsView: View {
    var body: some View {
        HStack(spacing: 12) {
            Button {
                // 로그아웃
            } label: {
                Text("로그아웃")
                    .font(.B2)
                    .foregroundStyle(.gray400)
            }
            .contentShape(Rectangle())
            Rectangle()
                .frame(width: 1, height: 16)
                .foregroundStyle(.gray300)
            Button {
                // 탈퇴하기
            } label: {
                Text("탈퇴하기")
                    .font(.B2)
                    .foregroundStyle(.gray400)
            }
        }
        .frame(alignment: .center)
    }
}

#Preview {
    MypageMainView()
}
