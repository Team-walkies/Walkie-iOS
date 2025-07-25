//
//  CircleProgressSkeletonView.swift
//  Walkie-iOS
//
//  Created by 고아라 on 7/25/25.
//

import SwiftUI
import WalkieCommon

struct CircleProgressSkeletonView: View {
    
    let type: CircleProgressType = .inMain
    
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(
                    WalkieCommonAsset.gray100.swiftUIColor,
                    lineWidth: type.lineWidth
                )
            
            Circle()
                .inset(by: type.lineWidth / 2)
                .trim(from: 0, to: 0)
            
            VStack(
                spacing: 12
            ) {
                SkeletonRect(
                    width: 100,
                    height: 20,
                    cornerRadius: 8
                )
                
                SkeletonRect(
                    width: 100,
                    height: 36,
                    cornerRadius: 8
                )
            }
            .frame(width: type.size, height: type.size)
        }
    }
}
