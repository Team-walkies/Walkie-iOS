//
//  MypageMainItemView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 2/21/25.
//

import SwiftUI

struct MypageMainItemView: View {
    let icon: Image
    let title: String
    let action: () -> Void
    let isVersion: Bool
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 0) {
                icon
                    .frame(width: 36, height: 36)
                    .padding(.trailing, 8)
                Text(title)
                    .font(.B2)
                    .foregroundStyle(.gray700)
                Spacer()
                if isVersion {
                    Text("v1.0.0")
                        .font(.B2)
                        .foregroundStyle(.gray400)
                } else {
                    Image(.icChevronRight)
                        .frame(width: 28, height: 28)
                        .foregroundColor(.gray300)
                }
            }
            .frame(height: 52)
        }.contentShape(Rectangle())
    }
}
