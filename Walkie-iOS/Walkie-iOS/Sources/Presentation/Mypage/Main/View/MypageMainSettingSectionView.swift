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
        if case let .loaded(state) = viewModel.state {
            MypageMainSectionView(title: MypageItem.setting.title) {
                ForEach([
                    MypageSettingSectionItem.myInfo(isPublic: state.isPublic),
                    MypageSettingSectionItem.pushNotification(
                        notifyEggHatches: NotificationManager.shared.getNotificationMode()
                    )
                ], id: \.title) { item in
                    MypageMainItemView(
                        viewModel: viewModel,
                        item: item
                    )
                }
            }
        }
    }
}
