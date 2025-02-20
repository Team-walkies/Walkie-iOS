//
//  MypageMainServiceSectionView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 2/21/25.
//

import SwiftUI

struct MypageMainServiceSectionView: View {
    var body: some View {
        MypageMainSectionView(title: MypageItem.service.title) {
            ForEach([MypageServiceSectionItem.notice, .privacyPolicy, .appVersion], id: \.title) { item in
                MypageMainItemView(
                    icon: item.icon,
                    title: item.title,
                    action: item.action,
                    isVersion: item == .appVersion
                )
            }
        }
    }
}
