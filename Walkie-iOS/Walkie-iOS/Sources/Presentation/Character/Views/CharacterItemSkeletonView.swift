//
//  CharacterItemSkeletonView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/19/25.
//

import SwiftUI
import WalkieCommon

struct CharacterItemSkeletonView: View {
    @Environment(\.screenWidth) var screenWidth
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            SkeletonRect(isGray100: false, width: 80, height: 80, cornerRadius: 40)
                .padding(.top, 26)
                .padding(.bottom, 8)
            SkeletonRect(isGray100: false, width: (screenWidth - 16*2 - 11)/2 - 60, height: 20, cornerRadius: 8)
                .padding(.bottom, 8)
            SkeletonRect(isGray100: false, width: 40, height: 20, cornerRadius: 8)
                .padding(.bottom, 26)
        }
        .frame(width: (screenWidth - 16*2 - 11)/2, height: 192)
        .background(WalkieCommonAsset.gray100.swiftUIColor)
        .cornerRadius(20, corners: .allCorners)
    }
}

#Preview {
    CharacterItemSkeletonView()
}
