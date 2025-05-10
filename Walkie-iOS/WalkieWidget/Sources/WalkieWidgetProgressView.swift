//
//  WalkieWidgetProgressView.swift
//  Walkie-iOS
//
//  Created by ahra on 3/18/25.
//

import SwiftUI
import ActivityKit
import WalkieCommon

struct ProgressInfoStruct {
    let isLiveActivity: Bool
    let place: String
    let leftDistance: Double
    let totalDistance: Double
}

struct WalkieWidgetProgressView: View {
    
    var info: ProgressInfoStruct
    
    var body: some View {
        if info.isLiveActivity {
            HStack {
                Spacer()
                
                Image(.imgWidgetLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 76, height: 24)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 17)
            .padding(.bottom, 12)
            .padding(.trailing, 25)
        }
        
        VStack(alignment: .leading, spacing: 1) {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(info.place)")
                    .font(.B2)
                    .foregroundColor(info.isLiveActivity
                                     ? WalkieCommonAsset.gray500.swiftUIColor
                                     : WalkieCommonAsset.gray400.swiftUIColor)
                
                if info.leftDistance == 0 {
                    Text("도착 완료! 알을 확인해보세요")
                        .font(.H3)
                        .foregroundColor(info.isLiveActivity ? .black : .white)
                } else {
                    let formatLeft = formatDistance(Double(info.leftDistance))
                    HighlightTextAttribute(
                        text: "도착까지 \(formatLeft) 남음",
                        textColor: info.isLiveActivity ? .black : .white,
                        font: .H3,
                        highlightText: "\(formatLeft)",
                        highlightColor: info.isLiveActivity
                        ? WalkieCommonAsset.blue400.swiftUIColor
                        : WalkieCommonAsset.blue200.swiftUIColor,
                        highlightFont: .H3
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            HStack(alignment: .bottom, spacing: 2) {
                ProgressBarView(
                    isSmall: false,
                    current: info.totalDistance - info.leftDistance,
                    total: info.totalDistance,
                    isDynamicIsland: true,
                    isLiveActivity: info.isLiveActivity
                )
                
                Image(.icWidgetDistance)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 22)
                    .padding(.trailing, 25)
                    .foregroundColor(info.isLiveActivity ? WalkieCommonAsset.gray400.swiftUIColor : WalkieCommonAsset.blue300.swiftUIColor)
            }
        }
        .padding(.leading, 30)
        .padding(.bottom, 30)
        .frame(maxWidth: .infinity)
    }
}
