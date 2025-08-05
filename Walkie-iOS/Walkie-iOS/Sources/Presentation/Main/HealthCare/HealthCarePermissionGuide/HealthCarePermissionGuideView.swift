//
//  HealthCarePermissionGuideView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 8/5/25.
//

import SwiftUI
import WalkieCommon

struct HealthCarePermissionGuideView: View {
    
    @StateObject var viewModel: HealthCarePermissionGuideViewModel
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        GeometryReader { geometry in
            VStack(
                alignment: .center,
                spacing: 0
            ) {
                NavigationBar(showBackButton: true)
                VStack(
                    alignment: .center,
                    spacing: 0
                ) {
                    Spacer(minLength: 0)
                    Text("걸음 기록을 보기 위해\n건강 권한을 꼭 허용해주세요!")
                        .font(.H2)
                        .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 12)
                    Text("Apple 건강 앱의 정확한 걸음 수를 가져올게요")
                        .font(.B2)
                        .foregroundStyle(WalkieCommonAsset.gray500.swiftUIColor)
                        .padding(.bottom, 32)
                    WalkieLottieView(
                        lottie: .healthCarePermission,
                        isPlaying: true,
                        isLoop: true
                    )
                    .frame(
                        width: (geometry.size.height * 0.34)/0.8,
                        height: geometry.size.height * 0.34
                    )
                    Spacer(minLength: 0)
                }
                Spacer(minLength: 0)
                CTAButton(
                    title: "확인했어요",
                    style: .primary,
                    size: .small,
                    isEnabled: true,
                    buttonAction: {
                        viewModel.action(.checkedButtonTapped)
                    }
                )
                .padding(.bottom, 4)
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
