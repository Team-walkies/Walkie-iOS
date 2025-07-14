//
//  CalorieView.swift
//  Walkie-iOS
//
//  Created by 고아라 on 7/14/25.
//

import SwiftUI
import WalkieCommon
import Kingfisher

struct CalorieView: View {
    
    var caloriesName: String
    var caloriesDescription: String
    var caloriesUrl: String
    
    var body: some View {
        HStack(
            spacing: 8
        ) {
            if let imgURL = URL(string: caloriesUrl) {
                KFImage.url(imgURL)
                    .loadDiskFileSynchronously(true)
                    .cacheMemoryOnly()
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }
            
            VStack(
                alignment: .leading,
                spacing: 0
            ) {
                HighlightTextAttribute(
                    text: "\(caloriesName)만큼 칼로리 소모",
                    textColor: WalkieCommonAsset.gray700.swiftUIColor,
                    font: .H6,
                    highlightText: "\(caloriesName)",
                    highlightColor: WalkieCommonAsset.blue400.swiftUIColor,
                    highlightFont: .H6
                )
                
                Text(caloriesDescription)
                    .font(.B2)
                    .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
            }
            
            Spacer()
        }
        .padding(.vertical, 16)
        .padding(.leading, 16)
        .frame(maxWidth: .infinity)
        .background(.white)
        .cornerRadius(8, corners: .allCorners)
    }
}
