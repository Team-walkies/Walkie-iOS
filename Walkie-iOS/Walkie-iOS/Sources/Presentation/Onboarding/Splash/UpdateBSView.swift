//
//  UpdateBSView.swift
//  Walkie-iOS
//
//  Created by 고아라 on 6/13/25.
//

import SwiftUI
import WalkieCommon

struct UpdateBSView: View {
    
    var body: some View {
        VStack(
            alignment: .center,
            spacing: 20
        ) {
            VStack(
                alignment: .center,
                spacing: 4
            ) {
                Text("새로운 버전이 업데이트 되었어요")
                    .font(.H4)
                    .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                
                Text("유저분들의 의견을 반영하여 사용성을 개선했어요!\n지금 바로 업데이트하고 즐겨보세요")
                    .font(.B2)
                    .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
                    .multilineTextAlignment(.center)
            }
            
            HStack(
                spacing: 8
            ) {
                CTAButton(
                    title: "앱을 종료할게요",
                    style: .modal,
                    size: .modal,
                    isEnabled: true,
                    buttonAction: {
                        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            exit(0)
                        }
                    }
                )
                
                CTAButton(
                    title: "업데이트",
                    style: .primary,
                    size: .modal,
                    isEnabled: true,
                    buttonAction: {
                        openAppStore()
                    }
                )
            }
        }
    }
    
    private func openAppStore() {
        guard let url = URL(string: URLConstant.appStoreURL) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

#Preview {
    UpdateBSView()
}
