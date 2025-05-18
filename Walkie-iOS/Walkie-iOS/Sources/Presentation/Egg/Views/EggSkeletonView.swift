//
//  EggSkeletonView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/19/25.
//
import WalkieCommon
import SwiftUI

struct EggSkeletonView: View {
    
    private let gridColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Text("보유한 알")
                .font(.H2)
                .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
            Rectangle()
                .foregroundStyle(WalkieCommonAsset.gray100.swiftUIColor)
                .frame(width: 20, height: 20)
                .cornerRadius(8, corners: .allCorners)
            Spacer()
        }.padding(.bottom, 4)
        Text("같이 걷고 싶은 알을 선택해 주세요")
            .font(.B2)
            .foregroundStyle(WalkieCommonAsset.gray500.swiftUIColor)
            .padding(.bottom, 20)
        LazyVGrid(columns: gridColumns, alignment: .center, spacing: 11) {
            ForEach(0..<10, id: \.self) { _ in
                EggItemSkeletonView()
            }
        }
        .ignoresSafeArea()
        .padding(.bottom, 48)
    }
}

private struct EggItemSkeletonView: View {
    
    @Environment(\.screenWidth) var screenWidth
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            SkeletonRect(width: 80, height: 80, cornerRadius: 0)
                .mask(
                    Image(.imgEggSkeleton)
                        .resizable()
                        .frame(width: 80, height: 80)
                )
                .padding(.top, 26)
                .padding(.bottom, 8)
            SkeletonRect(width: 40, height: 20, cornerRadius: 8)
                .padding(.bottom, 8)
            SkeletonRect(width: (screenWidth - 16*2 - 11)/2 - 60, height: 20, cornerRadius: 8)
                .padding(.bottom, 26)
        }
        .frame(width: (screenWidth - 16*2 - 11)/2, height: 188)
        .background(WalkieCommonAsset.gray100.swiftUIColor)
        .cornerRadius(20, corners: .allCorners)
    }
}
