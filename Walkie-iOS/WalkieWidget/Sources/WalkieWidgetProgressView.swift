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
    let currentDistance: Double
    let totalDistance: Double
}

struct WalkieWidgetProgressView: View {
    
    var info: ProgressInfoStruct
    
    var body: some View {
        let leftDistance = Int(info.totalDistance - info.currentDistance)
        if info.isLiveActivity {
            HStack {
                Spacer()
                
                Image("img_widget_logo")
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
                    .foregroundColor(WalkieCommonAsset.gray400.swiftUIColor)
                
                if leftDistance == 0 {
                    Text("도착 완료! 알을 확인해보세요")
                        .font(.H3)
                        .foregroundColor(.white)
                } else {
                    let formatLeft = formatDistance(Double(leftDistance))
                    HighlightTextAttribute(
                        text: "도착까지 \(formatLeft) 남음",
                        textColor: .white,
                        font: .H3,
                        highlightText: "\(formatLeft)",
                        highlightColor: WalkieCommonAsset.blue200.swiftUIColor,
                        highlightFont: .H3
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            HStack(alignment: .bottom, spacing: 2) {
                ProgressBarView(
                    isSmall: false,
                    current: info.currentDistance,
                    total: info.totalDistance,
                    isDynamicIsland: true
                )
                
                Image("ic_widget_spot")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 22)
                    .padding(.trailing, 25)
            }
        }
        .padding(.leading, 30)
        .padding(.bottom, 30)
        .frame(maxWidth: .infinity)
    }
}
