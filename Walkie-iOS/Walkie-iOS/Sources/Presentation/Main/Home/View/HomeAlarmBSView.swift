//
//  HomeAlarmBSView.swift
//  Walkie-iOS
//
//  Created by ahra on 4/12/25.
//

import SwiftUI

import WalkieCommon

struct HomeAlarmBSView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    @Environment(\.screenWidth) var screenWidth
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(
            spacing: 20
        ) {
            VStack(
                alignment: .center,
                spacing: 4
            ) {
                Text("걸음 수가 채워지면\n알 부화 소식을 알려드릴게요!")
                    .font(.H4)
                    .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                    .multilineTextAlignment(.center)
                
                Text("‘마이 > ‘푸시 알림’에서 관리할 수 있어요")
                    .font(.B2)
                    .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
            }
            
            Image(.imgAlarmBs)
                .resizable()
                .scaledToFit()
                .frame(height: 143)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
            
            HStack(
                spacing: 8
            ) {
                Button(action: {
                    isPresented = false
                    viewModel.action(.showEventModal)
                }, label: {
                    Text("나중에")
                        .font(.B1)
                        .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
                        .frame(maxWidth: .infinity)
                })
                .frame(width: (screenWidth - 40) / 2, height: 54)
                .background(WalkieCommonAsset.gray100.swiftUIColor)
                .cornerRadius(12, corners: .allCorners)
                
                Button(action: {
                    openSettings()
                    isPresented = false
                    viewModel.action(.showEventModal)
                }, label: {
                    Text("알림받기")
                        .font(.B1)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                })
                .frame(width: (screenWidth - 40) / 2, height: 54)
                .background(WalkieCommonAsset.blue300.swiftUIColor)
                .cornerRadius(12, corners: .allCorners)
            }
            .padding(.horizontal, 16)
        }
        .padding(.top, 24)
        .background(.white)
    }
    
    private func openSettings() {
        NotificationManager.shared.checkNotificationPermission { permission in
            switch permission {
            case .notDetermined:
                NotificationManager.shared.requestAuthorization()
            default:
                NotificationManager.shared.openSettings()
            }
        }
    }
}
