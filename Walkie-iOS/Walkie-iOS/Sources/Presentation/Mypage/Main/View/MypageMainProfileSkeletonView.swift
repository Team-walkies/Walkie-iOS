//
//  MypageMainProfileSkeletonView.swift
//  Walkie-iOS
//
//  Created by 고아라 on 5/16/25.
//

import SwiftUI

import WalkieCommon

struct MypageMainProfileSkeletonView: View {
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            HStack(
                alignment: .center,
                spacing: 8
            ) {
                SkeletonRect(
                    width: 108,
                    height: 34,
                    cornerRadius: 17
                )
                SkeletonRect(
                    width: 65,
                    height: 34,
                    cornerRadius: 17
                )
                Spacer(minLength: 0)
            }
            
            SkeletonRect(
                width: 240,
                height: 24,
                cornerRadius: 12
            )
        }
    }
}
