//
//  HomeHealthcareBSView.swift
//  Walkie-iOS
//
//  Created by 고아라 on 8/4/25.
//

import SwiftUI
import WalkieCommon

struct HomeHealthcareBSView: View {
    
    @Environment(\.screenHeight) var screenHeight
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appCoordinator: AppCoordinator
    
    var body: some View {
        VStack(
            alignment: .center,
            spacing: 20
        ) {
            VStack(
                alignment: .center,
                spacing: 12
            ) {
                Text("NEW")
                    .font(.C1)
                    .foregroundColor(WalkieCommonAsset.blue400.swiftUIColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(WalkieCommonAsset.blue50.swiftUIColor)
                    .cornerRadius(8, corners: .allCorners)
                
                VStack(
                    alignment: .center,
                    spacing: 4
                ) {
                    Text("이제 걸음 기록을 볼 수 있어요!")
                        .font(.H3)
                        .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                    
                    Text("원하는 목표 걸음 수를 설정하고 달성해 보세요!")
                        .font(.B2)
                        .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
                }
            }
            
            WalkieLottieView(
                lottie: .healthcareInfo,
                isPlaying: true,
                isLoop: true
            )
            .frame(height: screenHeight * 0.48)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 35)
            
            VStack(
                alignment: .center,
                spacing: 8
            ) {
                CTAButton(
                    title: "사용해보기",
                    style: .primary,
                    size: .large,
                    isEnabled: true,
                    buttonAction: {
                        dismiss()
                        appCoordinator.push(AppScene.healthcare)
                    }
                )
                
                Button(action: {
                    dismiss()
                }, label: {
                    Text("나중에 하기")
                        .font(.B2)
                        .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                })
            }
        }
        .padding(.top, 24)
        .padding(.bottom, 4)
    }
}
