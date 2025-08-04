//
//  HealthCarePermissionNotAllowedGuideView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 8/5/25.
//

import SwiftUI
import WalkieCommon

struct HealthCarePermissionNotAllowedGuideView: View {
    
    @StateObject var viewModel: HealthCarePermissionNotAllowedGuideViewModel
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        GeometryReader { geometry in
            NavigationBar(showBackButton: true)
            VStack(
                alignment: .center,
                spacing: 0
            ) {
                Spacer(minLength: 0)
                VStack(
                    alignment: .center,
                    spacing: 0
                ) {
                    WalkieLottieView(lottie: .healthCarePermission, isPlaying: true)
                        .frame(width: (geometry.size.height * 0.34)/0.8, height: geometry.size.height * 0.34)
                        .padding(.bottom, 24)
                    Text("걸음 기록을 보려면\n건강 권한을 허용해주세요")
                        .font(.B1)
                        .foregroundStyle(WalkieCommonAsset.gray500.swiftUIColor)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 16)
                    CTAButton(
                        title: "허용하기",
                        style: .primary,
                        size: .small,
                        isEnabled: true,
                        buttonAction: {
                            viewModel.action(.permitButtonTapped)
                        }
                    )
                    .frame(width: 120)
                }
                .frame(maxWidth: .infinity)
                Spacer(minLength: 0)
            }
        }
        .onChange(of: scenePhase, initial: false) { _, newValue in
            switch newValue {
            case .background:
                viewModel.action(.returnFromPermissionSetting)
            default:
                break
            }
        }
    }
}
