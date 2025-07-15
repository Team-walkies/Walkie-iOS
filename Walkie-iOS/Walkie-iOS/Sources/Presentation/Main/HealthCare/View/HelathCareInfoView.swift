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
    
    var body: some View {
        ZStack(
            alignment: .topTrailing
        ) {
            VStack(
                spacing: 12
            ) {
                if infoState.continuousDays > 0 && infoState.isToday {
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
                
                Text("오늘의 걸음")
                    .font(.H5)
                    .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                    .alignTo(.leading)
                    .padding(.top, infoState.continuousDays > 0 ? 0 : 12)
                    .padding(.leading, 16)
                
                CircleProgressView(
                    type: .inMain,
                    targetStep: infoState.targetSteps,
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
            
            let goalAchieve = infoState.nowSteps >= infoState.targetSteps.rawValue
            if goalAchieve {
                VStack(
                    spacing: 0
                ) {
                    Image(.icFirebadge)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    
                    Text("달성")
                        .font(.C1)
                        .foregroundColor(WalkieCommonAsset.blue400.swiftUIColor)
                }
                .padding(.top, infoState.continuousDays > 0 ? 52 : 16)
                .padding(.trailing, 16)
            }
        }
        .frame(width: screenWidth - 32)
        .background(.white)
        .cornerRadius(20, corners: .allCorners)
    }
}
