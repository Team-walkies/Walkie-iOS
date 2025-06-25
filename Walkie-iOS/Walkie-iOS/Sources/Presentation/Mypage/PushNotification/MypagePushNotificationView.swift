//
//  MypagePushNotificationView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/1/25.
//
import SwiftUI

struct MypagePushNotificationView: View {

    @StateObject var viewModel: MypagePushNotificationViewModel
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        NavigationBar(
            title: "푸시 알림",
            showBackButton: true
        )
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: 8) {
                    SwitchOptionItemView(
                        title: "알 부화 알림",
                        subtitle: "알이 부화하면 알려드려요",
                        isOn: viewModel.state.notifyEggHatches,
                        toggle: {
                            viewModel.action(.toggleNotifyEggHatches)
                        }
                    )
                }
                .padding(.top, 12)
                .padding(.horizontal, 16)
        }
        .onChange(of: scenePhase, initial: true) { _, newPhase in
            if newPhase == .active {
                viewModel.action(.updatedNotificationPermission)
            }
        }
    }
}
