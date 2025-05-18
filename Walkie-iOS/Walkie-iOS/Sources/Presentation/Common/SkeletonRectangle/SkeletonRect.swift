//
//  SkeletonRect.swift
//  Walkie-iOS
//
//  Created by 고아라 on 5/14/25.
//

import SwiftUI

import WalkieCommon

struct SkeletonRect: View {
    
    let isGray100: Bool
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat
    
    init(
        isGray100: Bool = true,
        width: CGFloat,
        height: CGFloat,
        cornerRadius: CGFloat
    ) {
        self.isGray100 = isGray100
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        Rectangle()
            .fill(
                isGray100
                ? WalkieCommonAsset.gray100.swiftUIColor
                : WalkieCommonAsset.gray200.swiftUIColor)
            .frame(
                width: width,
                height: height
            )
            .cornerRadius(
                cornerRadius,
                corners: .allCorners
            )
            .applySkeleton(isGray100: isGray100)
    }
}
