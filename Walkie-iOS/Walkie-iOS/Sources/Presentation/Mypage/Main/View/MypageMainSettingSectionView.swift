//
//  MypageMainSettingSectionView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 2/21/25.
//

import SwiftUI

struct MypageMainSettingSectionView: View {
    var body: some View {
        MypageMainSectionView(title: MypageItem.setting.title) {
            ForEach([MypageSettingSectionItem.myInfo, .pushNotification], id: \.title) { item in
                MypageMainItemView(
                    icon: item.icon,
                    title: item.title,
                    action: item.action,
                    isVersion: false)
            }
        }
    }
}
