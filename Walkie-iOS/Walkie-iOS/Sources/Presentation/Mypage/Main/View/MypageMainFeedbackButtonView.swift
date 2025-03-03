//
//  MypageMainFeedbackButtonView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/1/25.
//

import SwiftUI

struct MypageMainFeedbackButtonView: View {
    var body: some View {
        NavigationLink(destination: EmptyView().navigationBarBackButtonHidden()) {
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
        .buttonStyle(PlainButtonStyle())
        .frame(height: 72)
        .background(.gray100)
        .cornerRadius(12)
    }
}
