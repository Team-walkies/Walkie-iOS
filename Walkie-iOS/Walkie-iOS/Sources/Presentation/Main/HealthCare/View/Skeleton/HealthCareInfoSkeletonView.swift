//
//  HealthCareInfoSkeletonView.swift
//  Walkie-iOS
//
//  Created by 고아라 on 7/25/25.
//

import SwiftUI
import WalkieCommon

struct HealthCareInfoSkeletonView: View {
    
    @Environment(\.screenWidth) var screenWidth
    
    var body: some View {
        ZStack(
            alignment: .topTrailing
        ) {
            VStack(
                spacing: 12
            ) {
                VStack(
                    spacing: 7
                ) {
                    
                    HStack(
                        spacing: 0
                    ) {
                        SkeletonRect(
                            width: 100,
                            height: 20,
                            cornerRadius: 8
                        )
                        
                        Spacer()
                    }
                    .padding(.top, 8)
                    .padding(.leading, 16)
                    
                    Rectangle()
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(WalkieCommonAsset.gray100.swiftUIColor)
                }
                
                Text("오늘의 걸음")
                    .font(.H5)
                    .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                    .alignTo(.leading)
                    .padding(.top, 12)
                    .padding(.leading, 16)
                
                CircleProgressSkeletonView()
                
                HStack(
                    spacing: 12
                ) {
                    let width = (screenWidth - 76) / 2
                    
                    VStack(
                        spacing: 4
                    ) {
                        Text("이동거리")
                            .font(.B2)
                            .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
                        
                        HStack(
                            alignment: .center
                        ) {
                            SkeletonRect(
                                isGray100: false,
                                width: 80,
                                height: 20,
                                cornerRadius: 8
                            )
                        }
                        .frame(width: width, height: 38)
                        .background(WalkieCommonAsset.gray50.swiftUIColor)
                        .cornerRadius(8, corners: .allCorners)
                    }
                    
                    VStack(
                        spacing: 4
                    ) {
                        Text("소모 칼로리")
                            .font(.B2)
                            .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
                        
                        HStack(
                            alignment: .center
                        ) {
                            SkeletonRect(
                                isGray100: false,
                                width: 80,
                                height: 20,
                                cornerRadius: 8
                            )
                        }
                        .frame(width: width, height: 38)
                        .background(WalkieCommonAsset.gray50.swiftUIColor)
                        .cornerRadius(8, corners: .allCorners)
                    }
                }
                .padding(.bottom, 16)
            }
        }
        .frame(width: screenWidth - 32)
        .background(.white)
        .cornerRadius(20, corners: .allCorners)
    }
}
