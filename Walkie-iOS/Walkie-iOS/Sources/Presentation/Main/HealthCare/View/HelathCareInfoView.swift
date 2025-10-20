//
//  HelathCareInfoView.swift
//  Walkie-iOS
//
//  Created by 고아라 on 7/14/25.
//

import SwiftUI
import WalkieCommon

struct HealthCareInfoView: View {
    
    let infoState: HealthCareViewModel.HealthCareInfoState
    @EnvironmentObject var appCoordinator: AppCoordinator
    @Environment(\.screenWidth) var screenWidth
    @AppStorage(DefaultsKey.targetStep) private var targetStepStore = 6000
    @Binding var showTooltip: Bool
    
    var targetStep: TargetStep {
        if infoState.isToday {
            return TargetStep(rawValue: targetStepStore) ?? .six
        } else {
            return infoState.targetSteps
        }
    }
    
    var eggButtonState: GetEggButtonState {
        if infoState.isToday {
            if infoState.nowSteps >= self.targetStep.rawValue {
                return infoState.eggButtonState == .received ? .received : .available
            } else {
                return infoState.eggButtonState
            }
        } else {
            return infoState.eggButtonState
        }
    }
    
    var body: some View {
        ZStack(
            alignment: .topTrailing
        ) {
            let isConsecutiveToday = infoState.continuousDays > 0 && infoState.isToday
            VStack(
                spacing: 12
            ) {
                if isConsecutiveToday {
                    VStack(
                        spacing: 7
                    ) {
                        HStack(
                            spacing: 2
                        ) {
                            Image(.icFire)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .padding(.trailing, 2)
                            
                            Text("\(infoState.continuousDays)일 연속")
                                .font(.B2)
                                .foregroundColor(WalkieCommonAsset.blue400.swiftUIColor)
                            
                            Text("목표 달성 중")
                                .font(.B2)
                                .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                            
                            Spacer()
                        }
                        .padding(.top, 8)
                        .padding(.leading, 16)
                        
                        Rectangle()
                            .frame(height: 1)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(WalkieCommonAsset.gray100.swiftUIColor)
                    }
                }
                
                Text("일일 걸음수")
                    .font(.H5)
                    .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                    .alignTo(.leading)
                    .padding(.top, isConsecutiveToday ? 0 : 12)
                    .padding(.leading, 16)
                
                CircleProgressView(
                    type: .inMain,
                    targetStep: self.targetStep,
                    nowStep: infoState.nowSteps,
                    isToday: infoState.isToday
                )
                .environment(appCoordinator)
                
                HStack(
                    spacing: 12
                ) {
                    let width = (screenWidth - 76) / 2
                    
                    VStack(
                        spacing: 4
                    ) {
                        Text("이동거리")
                            .font(.B2)
                            .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
                        
                        HStack(
                            alignment: .bottom,
                            spacing: 2
                        ) {
                            Text(String(format: "%.1f", infoState.nowDistance))
                                .font(.H3)
                                .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                            
                            Text("km")
                                .font(.B2)
                                .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                                .padding(.bottom, 3)
                        }
                        .frame(width: width, height: 38)
                        .background(WalkieCommonAsset.gray50.swiftUIColor)
                        .cornerRadius(8, corners: .allCorners)
                    }
                    
                    VStack(
                        spacing: 4
                    ) {
                        Text("소모 칼로리")
                            .font(.B2)
                            .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
                        
                        HStack(
                            alignment: .bottom,
                            spacing: 2
                        ) {
                            Text("\(infoState.nowCalories)")
                                .font(.H4)
                                .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                            
                            Text("kcal")
                                .font(.B2)
                                .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                                .padding(.bottom, 3)
                        }
                        .frame(width: width, height: 38)
                        .background(WalkieCommonAsset.gray50.swiftUIColor)
                        .cornerRadius(8, corners: .allCorners)
                    }
                }
                .padding(.bottom, 16)
            }
            
            HealthCareGetEggButtonView(
                buttonState: eggButtonState,
                action: {
                    switch eggButtonState {
                    case .available:
                        return appCoordinator.push(AppScene.egg)
                    case .pending:
                        return showTooltip.toggle()
                    case .received:
                        return ()
                    }
                }
            )
            .padding(.top, isConsecutiveToday ? 48 : 12)
            .padding(.trailing, 16)
            
            if showTooltip {
                VStack(
                    alignment: .trailing,
                    spacing: 0
                ) {
                    Image(.icTip)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 10, height: 8)
                        .padding(.trailing, 18)
                    
                    Text("걸음 수를 채우면 알을 받아요")
                        .font(.B2)
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(WalkieCommonAsset.gray600.swiftUIColor)
                        .cornerRadius(8, corners: .allCorners)
                }
                .padding(.top, isConsecutiveToday ? 108 : 72)
                .padding(.trailing, 12)
            }
        }
        .frame(width: screenWidth - 32)
        .background(.white)
        .cornerRadius(20, corners: .allCorners)
        .onChange(of: infoState.eggButtonState) { _, newValue in
            guard case .pending = newValue else {
                showTooltip = false
                return
            }
        }
    }
}
