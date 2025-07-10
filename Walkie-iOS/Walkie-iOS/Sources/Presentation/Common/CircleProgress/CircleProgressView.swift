//
//  CircleProgressView.swift
//  Walkie-iOS
//
//  Created by 고아라 on 7/10/25.
//

import SwiftUI
import WalkieCommon

struct CircularProgressBar: View {
    
    var type: CircleProgressType
    var targetStep: Int
    var nowStep: Int
    
    private var progress: Double {
        guard targetStep > 0 else { return 0 }
        return min(Double(nowStep) / Double(targetStep), 1.0)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(
                    WalkieCommonAsset.gray100.swiftUIColor,
                    lineWidth: type.lineWidth
                )
            
            Circle()
                .inset(by: type.lineWidth / 2)
                .trim(from: 0, to: progress)
                .stroke(
                    WalkieCommonAsset.blue300.swiftUIColor,
                    style: StrokeStyle(
                        lineWidth: type.lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
            
            switch type {
            case .inCalendar:
                if progress >= 1 {
                    Image(.icFire)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                }
            case .inMain:
                VStack(
                    spacing: 0
                ) {
                    HStack(
                        spacing: 4
                    ) {
                        Text("목표")
                            .font(.B2)
                            .foregroundColor(WalkieCommonAsset.gray400.swiftUIColor)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(WalkieCommonAsset.gray50.swiftUIColor)
                            .cornerRadius(99, corners: .allCorners)
                        
                        HStack(
                            spacing: 0
                        ) {
                            Text(targetStep.formatted())
                                .font(.B1)
                                .foregroundColor(WalkieCommonAsset.gray400.swiftUIColor)
                            
                            Image(.icChevronDown)
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(WalkieCommonAsset.gray400.swiftUIColor)
                        }
                    }
                    .onTapGesture {
                        print("show targetStep bottomsheet")
                    }
                    
                    Text(nowStep.formatted())
                        .font(.H1)
                        .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                }
            }
        }
        .frame(width: type.size, height: type.size)
    }
}
