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
    let isOn: Bool
    let toggle: () -> Void
    
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
            Toggle(isOn: Binding(
                get: { isOn },
                set: { _ in toggle() }
            )) {
            }.tint(.blue300)
        }
        .padding(.horizontal, 16)
        .frame(height: 60)
        .background(.gray50)
        .cornerRadius(12, corners: .allCorners)
    }
}
