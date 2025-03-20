//
//  HomeHistoryItemView.swift
//  Walkie-iOS
//
//  Created by ahra on 2/21/25.
//

import SwiftUI

import WalkieCommon

struct HomeHistoryItemView: View {

    let item: HomeHistoryItem
    let width: CGFloat
    
    var body: some View {
        VStack(spacing: 8) {
            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: width, height: 69)
            
            VStack(spacing: 0) {
                Text(item.title)
                    .font(.H6)
                    .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                
                Text(item.count)
                    .font(.B2)
                    .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
            }
        }
    }
}
