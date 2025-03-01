//
//  MypageMainSettingSectionView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 2/21/25.
//

import SwiftUI

struct MypageMainSettingSectionView: View {
    
    @ObservedObject var viewModel: MypageMainViewModel
    
    var body: some View {
        MypageMainSectionView(title: MypageItem.setting.title) {
            ForEach([
                MypageSettingSectionItem.myInfo,
                MypageSettingSectionItem.pushNotification
            ], id: \.title) { item in
                MypageMainItemView(
                    item: item,
                    viewModel: viewModel)
            }
        }
    }
}
