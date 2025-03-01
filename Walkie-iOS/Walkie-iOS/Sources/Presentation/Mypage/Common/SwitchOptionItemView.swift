//
//  SwitchOptionItemView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/1/25.
//

import SwiftUI

struct SwitchOptionItemView: View {
    
    let title: String
    let subtitle: String
    @State var isOn: Bool
    
    var body: some View {
        ZStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(.H6)
                    .foregroundStyle(.gray700)
                Text(subtitle)
                    .font(.C1)
                    .foregroundStyle(.gray500)
            }.padding(.vertical, 10)
            Toggle(isOn: $isOn) {
            }.tint(.blue300)
        }
        .padding(.horizontal, 16)
        .frame(height: 60)
        .background(.gray50)
        .cornerRadius(12, corners: .allCorners)
    }
}

#Preview {
    SwitchOptionItemView(title: "프로필 공개", subtitle: "내 후기가 다른 사람에게 공개돼요", isOn: true).padding(.horizontal, 16)
}
