//
//  CircleProgressView.swift
//  Walkie-iOS
//
//  Created by 고아라 on 7/10/25.
//

import SwiftUI
import WalkieCommon

struct CircleProgressView: View {
    
    var type: CircleProgressType
    var targetStep: TargetStep
    var nowStep: Int
    var isToday: Bool = false
    var hasEggToReceive: Bool = false
    
    @State private var todayTargetStep: TargetStep?
    @EnvironmentObject var appCoordinator: AppCoordinator
    
    private var effectTarget: TargetStep {
        isToday ? (todayTargetStep ?? targetStep) : targetStep
    }
    
    private var progress: Double {
        guard effectTarget.rawValue > 0 else { return 0 }
        return min(Double(nowStep) / Double(effectTarget.rawValue), 1.0)
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
                if hasEggToReceive {
                    Image(.icEggReceive)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
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
                            Text(effectTarget.title)
                                .font(.B1)
                                .foregroundColor(WalkieCommonAsset.gray400.swiftUIColor)
                            
                            if isToday {
                                Image(.icChevronDown)
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(WalkieCommonAsset.gray400.swiftUIColor)
                            }
                        }
                    }
                    .onTapGesture {
                        guard isToday else { return }
                        appCoordinator.buildBottomSheet(height: 396) {
                            TargetStepBSView()
                        }
                    }
                    
                    Text(nowStep.formatted())
                        .font(.H1)
                        .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                }
            }
        }
        .frame(width: type.size, height: type.size)
        .onChange(of: targetStep) { _, _ in
            if !isToday { todayTargetStep = nil }
        }
    }
}
