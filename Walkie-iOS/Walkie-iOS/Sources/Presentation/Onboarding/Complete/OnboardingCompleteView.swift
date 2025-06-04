//
//  OnboardingCompleteView.swift
//  Walkie-iOS
//
//  Created by ahra on 3/4/25.
//

import SwiftUI

import WalkieCommon

struct OnboardingCompleteView: View {
    
    @State var tapStart: Bool = false
    @EnvironmentObject private var appCoordinator: AppCoordinator
    
    @State private var showCompleteImage = false
    @State private var showTitle = false
    @State private var showSubTitle = false
    
    var body: some View {
        VStack(
            alignment: .center,
            spacing: 0
        ) {
            VStack(
                alignment: .center,
                spacing: 24
            ) {
                Image(.imgGift)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 280, height: 280)
                    .opacity(showCompleteImage ? 1 : 0)
                
                VStack(
                    alignment: .center,
                    spacing: 12
                ) {
                    Text("\(UserManager.shared.getUserNickname)님,\n선물이 도착했어요!")
                        .font(.H2)
                        .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                        .multilineTextAlignment(.center)
                        .opacity(showTitle ? 1 : 0)
                    
                    Text("해파리 1마리와 알 1개를 받았어요")
                        .font(.B1)
                        .foregroundColor(WalkieCommonAsset.blue400.swiftUIColor)
                        .opacity(showSubTitle ? 1 : 0)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .frame(maxHeight: .infinity)
            
            Spacer()
            
            CTAButton(
                title: "함께 시작하자!",
                style: .primary,
                size: .large,
                isEnabled: true,
                buttonAction: {
                    appCoordinator.currentScene = .tabBar
                }
            )
            .padding(.bottom, 4)
            .onAppear {
                withAnimation(.easeOut(duration: 0.3)) {
                    showCompleteImage = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        showTitle = true
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        showSubTitle = true
                    }
                }
            }
        }
    }
}
