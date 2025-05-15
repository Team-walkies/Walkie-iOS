//
//  HomeStatsSkeletonView.swift
//  Walkie-iOS
//
//  Created by 고아라 on 5/14/25.
//

import SwiftUI

import WalkieCommon

struct HomeStatsSkeletonView: View {
    
    @Environment(\.screenWidth) var screenWidth
    
    var body: some View {
        VStack(spacing: 8) {
            SkeletonRect(
                width: screenWidth - 34,
                height: 371,
                cornerRadius: 20
            )
            
            SkeletonRect(
                width: screenWidth - 34,
                height: 52,
                cornerRadius: 12
            )
        }
    }
}

struct HomeHistorySkeletonView: View {
    
    @Environment(\.screenWidth) var screenWidth
    
    private let columns = [GridItem(.flexible())]
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            SkeletonRect(
                width: 109,
                height: 20,
                cornerRadius: 8
            )
            
            LazyHGrid(
                rows: columns,
                spacing: 8
            ) {
                ForEach(0..<3, id: \.self) { _ in
                    VStack {
                        SkeletonRect(
                            width: (screenWidth - 48) / 3,
                            height: 70,
                            cornerRadius: 12
                        )
                        
                        SkeletonRect(
                            width: (screenWidth - 48) / 3,
                            height: 20,
                            cornerRadius: 8
                        )
                    }
                }
            }
        }
        .padding(.top, 23)
        .padding(.horizontal, 16)
    }
}
