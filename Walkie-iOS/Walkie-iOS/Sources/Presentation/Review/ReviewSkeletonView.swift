//
//  ReviewSkeletonView.swift
//  Walkie-iOS
//
//  Created by ahra on 5/18/25.
//

import SwiftUI

import WalkieCommon

struct ReviewSkeletonView: View {
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            HStack(spacing: 4) {
                Text("기록")
                    .font(.B1)
                    .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
                
                SkeletonRect(
                    width: 20,
                    height: 20,
                    cornerRadius: 8
                )
            }
            .padding(.top, 12)
            
            VStack(spacing: 40) {
                ForEach(0..<2) { _ in
                    ReviewItemSkeletonView()
                }
            }
        }
    }
}

struct ReviewItemSkeletonView: View {
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                SkeletonRect(
                    width: 38,
                    height: 38,
                    cornerRadius: 19
                )
                
                SkeletonRect(
                    width: 100,
                    height: 20,
                    cornerRadius: 8
                )
                .padding(.leading, 8)
                
                Spacer()
                
                Image(.icMore)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            
            VStack(spacing: 12) {
                SkeletonRect(
                    width: 180,
                    height: 20,
                    cornerRadius: 8
                )
                
                Rectangle()
                    .fill(WalkieCommonAsset.gray200.swiftUIColor)
                    .frame(height: 1)
                    .padding(.horizontal, 16)
                
                HStack {
                    ForEach(0..<3) { _ in
                        SkeletonRect(
                            width: 82,
                            height: 20,
                            cornerRadius: 8
                        )
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 12)
            .cornerRadius(12, corners: .allCorners)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(WalkieCommonAsset.gray200.swiftUIColor, lineWidth: 1)
            )
            
            VStack(
                alignment: .leading,
                spacing: 8
            ) {
                SkeletonRect(
                    isGray100: false,
                    width: 80,
                    height: 20,
                    cornerRadius: 8
                )
                
                GeometryReader { geo in
                    SkeletonRect(
                        isGray100: false,
                        width: geo.size.width - 32,
                        height: 20,
                        cornerRadius: 8
                    )
                }
            }
            .padding(.all, 16)
            .background(WalkieCommonAsset.gray100.swiftUIColor)
            .cornerRadius(12, corners: .allCorners)
        }
    }
}

#Preview {
    ReviewItemSkeletonView()
}
