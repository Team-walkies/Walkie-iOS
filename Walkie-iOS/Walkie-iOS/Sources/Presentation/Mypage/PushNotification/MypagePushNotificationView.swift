//
//  MypagePushNotificationView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/1/25.
//
import SwiftUI
import WalkieCommon

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
                    if viewModel.state.showNotificationPermissionAlert {
                        PushNotificationOffAlertView(viewModel: viewModel)
                    }
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
                viewModel.action(.checkNotificationPermissionAndApply)
            }
        }
    }
}

private struct PushNotificationOffAlertView: View {
    let viewModel: MypagePushNotificationViewModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            Image(.icDangerGray)
                .resizable()
                .frame(width: 18, height: 18)
            Text("기기 알림이 꺼져있어요")
                .font(.B2)
                .foregroundStyle(WalkieCommonAsset.gray500.swiftUIColor)
            Spacer(minLength: 0)
            Button(
                action: {
                    viewModel.action(.openSettings)
                }, label: {
                    Text("알림 켜기")
                        .font(.B2)
                        .foregroundStyle(WalkieCommonAsset.blue400.swiftUIColor)
                }
            )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(WalkieCommonAsset.blue30.swiftUIColor)
        .clipShape(.rect(cornerRadius: 8))
        .innerBorder(
            color: WalkieCommonAsset.blue100.swiftUIColor,
            lineWidth: 1,
            padding: 1,
            cornerRadius: 8
        )
    }
}
