//
//  HomeAuthItemView.swift
//  Walkie-iOS
//
//  Created by ahra on 4/12/25.
//

import SwiftUI

import WalkieCommon

struct HomeAuthItemView: View {
    
    let item: HomeAuthItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Image(item.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                
                Text(item.title)
                    .font(.H6)
                    .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                
                Text("(필수)")
                    .font(.B2)
                    .foregroundColor(WalkieCommonAsset.blue400.swiftUIColor)
            }
            
            Text(item.subTitle)
                .font(.B2)
                .foregroundColor(WalkieCommonAsset.gray400.swiftUIColor)
        }
        .alignTo(.leading)
        .padding(.leading, 16)
        .frame(maxWidth: .infinity)
        .frame(height: 68)
        .background(WalkieCommonAsset.gray50.swiftUIColor)
        .cornerRadius(12, corners: .allCorners)
    }
}
