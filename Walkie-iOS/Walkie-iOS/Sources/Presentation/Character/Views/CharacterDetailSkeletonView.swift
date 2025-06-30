//
//  CharacterDetailSkeletonView.swift
//  Walkie-iOS
//
//  Created by 고아라 on 6/26/25.
//

import SwiftUI
import WalkieCommon

struct CharacterDetailSkeletonView: View {
    
    @Environment(\.screenWidth) var screenWidth
    
    var body: some View {
        VStack(
            spacing: 20
        ) {
            SkeletonRect(
                width: 180,
                height: 180,
                cornerRadius: 8
            )
            
            SkeletonRect(
                width: 57,
                height: 36,
                cornerRadius: 18
            )
            
            SkeletonRect(
                width: 180,
                height: 36,
                cornerRadius: 8
            )
            
            SkeletonRect(
                width: screenWidth - 32,
                height: 36,
                cornerRadius: 8
            )
            
            Spacer()
            
            CTAButton(
                title: "이 캐릭터와 같이 걷기",
                style: .primary,
                size: .large,
                isEnabled: true,
                buttonAction: { }
            )
            .padding(.bottom, 38)
        }
    }
}
