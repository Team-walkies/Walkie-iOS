//
//  SwitchOptionItemView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/1/25.
//

import SwiftUI

import WalkieCommon

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
                    .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
                Text(subtitle)
                    .font(.C1)
                    .foregroundStyle(WalkieCommonAsset.gray500.swiftUIColor)
            }.padding(.vertical, 10)
            Toggle(isOn: Binding(
                get: { isOn },
                set: { _ in toggle() }
            )) {
            }.tint(WalkieCommonAsset.blue300.swiftUIColor)
        }
        .padding(.horizontal, 16)
        .frame(height: 60)
        .background(WalkieCommonAsset.gray50.swiftUIColor)
        .cornerRadius(12, corners: .allCorners)
    }
}
