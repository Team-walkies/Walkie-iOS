//
//  MypagePushNotificationView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/1/25.
//

import SwiftUI

struct MypagePushNotificationView: View {
    
    @ObservedObject var viewModel: MypageMainViewModel
    
    var body: some View {
        NavigationBar(
            title: "푸시 알림",
            showBackButton: true)
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: 8) {
                    SwitchOptionItemView(
                        title: "오늘의 걸음 수",
                        subtitle: "하루 걸음 수를 알려드려요",
                        isOn: viewModel.pushNotificationState.notifyTodayWalkCount,
                        toggle: { viewModel.action(.toggleNotifyTodayWalkCount) }
                    )
                    SwitchOptionItemView(
                        title: "스팟 도착 알림",
                        subtitle: "스팟에 도착하면 알려드려요",
                        isOn: viewModel.pushNotificationState.notifyArrivedSpot,
                        toggle: { viewModel.action(.toggleNotifyArrivedSpot) }
                    )
                    SwitchOptionItemView(
                        title: "알 부화 알림",
                        subtitle: "알이 부화하면 알려드려요",
                        isOn: viewModel.pushNotificationState.notifyEggHatches,
                        toggle: { viewModel.action(.toggleNotifyEggHatches) }
                    )
                }
                .padding(.top, 12)
                .padding(.horizontal, 16)
        }
    }
}

#Preview {
    MypagePushNotificationView(viewModel: MypageMainViewModel())
}
