//
//  OnboardingCompleteView.swift
//  Walkie-iOS
//
//  Created by ahra on 3/4/25.
//

import SwiftUI

struct OnboardingCompleteView: View {
    
    @Binding var tapStart: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .center, spacing: 12) {
                    Text("\(UserManager.shared.getUserNickname)님,\n환영해요")
                        .font(.H2)
                        .foregroundColor(.gray700)
                        .multilineTextAlignment(.center)
                    
                    Text("해파리를 선물로 드릴게요")
                        .font(.B1)
                        .foregroundColor(.blue400)
                }
                .padding(.top, 136)
                
                Image(.imgJellyfish0)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(.top, 32)
                
                Spacer()
                
                CTAButton(
                    title: "함께 시작하자!",
                    style: .primary,
                    size: .large,
                    isEnabled: true,
                    buttonAction: {
                        tapStart = true
                        UserManager.shared.setTapStart()
                    }
                )
                .padding(.bottom, 4)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}
