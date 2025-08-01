//
//  HomeStatsView.swift
//  Walkie-iOS
//
//  Created by ahra on 2/21/25.
//

import SwiftUI

import WalkieCommon
import FirebaseAnalytics

struct HomeStatsView: View {
    
    let homeStatsState: HomeViewModel.HomeStatsState
    let stepState: HomeViewModel.StepState
    let leftStepState: HomeViewModel.LeftStepState
    let width: CGFloat
    
    @State var showWarning: Bool = false
    @State var warningTypes: [WarningType] = []
    @Environment(\.safeScreenHeight) private var safeScreenHeight
    @EnvironmentObject var appCoordinator: AppCoordinator
    
    var body: some View {
        
        let statsHeight = max(safeScreenHeight - 359, 360)
        let eggHeight = statsHeight * 0.57
        let eggWidth = eggHeight * 1.3
        let emptyButtonInset = eggHeight / 3.2
        
        ZStack(alignment: .bottom) {
            LinearGradient(
                gradient: Gradient(stops: [
                    Gradient.Stop(
                        color: homeStatsState.eggGradientColors[0],
                        location: 0.0),
                    Gradient.Stop(
                        color: homeStatsState.eggGradientColors[1],
                        location: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .cornerRadius(20, corners: .allCorners)
            .onTapGesture {
                appCoordinator.push(AppScene.healthcare)
            }
            
            ZStack(alignment: .bottom) {
                if let eggEffect = homeStatsState.eggEffectImage {
                    Image(eggEffect)
                        .resizable()
                        .scaledToFill()
                        .frame(width: width, height: 343)
                }
            }
            .allowsHitTesting(false)
            
            VStack(spacing: 4) {
                HStack(alignment: .bottom, spacing: 0) {
                    if stepState.todayStep < 0 {
                        Text("0")
                            .font(.H1)
                            .foregroundColor(.white)
                            .padding(.trailing, 4)
                    } else {
                        Text("\(stepState.todayStep)")
                            .font(.H1)
                            .foregroundColor(.white)
                            .padding(.trailing, 4)
                    }
                    Text("걸음")
                        .font(.B1)
                        .foregroundColor(.white)
                        .padding(.bottom, 5)
                    Spacer(minLength: 0)
                    Image(.icChevronRight)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(.white)
                        .padding(.trailing, 20)
                        .padding(.bottom, 14)
                    
                }
                .allowsHitTesting(false)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 12)
                .padding(.leading, 20)
                
                HStack(alignment: .center, spacing: 8) {
                    let distanceStr = String(format: "%.1f", stepState.todayDistance)
                    Text("\(distanceStr)km")
                        .font(.B1)
                        .foregroundColor(.white)
                    Rectangle()
                        .frame(width: 1, height: 16)
                        .foregroundStyle(.white)
                        .opacity(0.3)
                    Text("\(stepState.todayCalories)Kcal")
                        .font(.B1)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .allowsHitTesting(false)
                .padding(.leading, 20)
                
                Spacer()
                
                if homeStatsState.hasEgg {
                    ZStack {
                        Image(.imgSpeechbubble)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 136, height: 45)
                        
                        HStack(spacing: 0) {
                            Text("부화까지 ")
                                .font(.B2)
                                .foregroundColor(WalkieCommonAsset.gray400.swiftUIColor)
                            
                            Text("\(leftStepState.leftStep)걸음")
                                .font(.B2)
                                .foregroundColor(.white)
                        }
                        .padding(.top, -8)
                    }
                    .padding(.bottom, -17)
                    
                    Image(homeStatsState.eggImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: eggWidth, height: eggHeight)
                } else {
                    Image(homeStatsState.eggImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: eggWidth, height: eggHeight)
                        .overlay(alignment: .bottom) {
                            if !showWarning {
                                Button(action: {
                                    appCoordinator.push(AppScene.egg)
                                }, label: {
                                    Text("알을 선택해 주세요")
                                        .font(.H5)
                                        .foregroundColor(WalkieCommonAsset.blue50.swiftUIColor)
                                        .underline()
                                })
                                .frame(height: 24)
                                .padding(.bottom, emptyButtonInset)
                            }
                        }
                }
            }
            
            if !warningTypes.isEmpty {
                VStack(alignment: .trailing, spacing: 0) {
                    ForEach(Array(warningTypes.enumerated()), id: \.element) { index, type in
                        HomeWariningView(type: type)
                        
                        if index < warningTypes.count - 1 {
                            Spacer().frame(height: 4)
                        }
                    }
                    
                    Image(.icBubble)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 21)
                        .padding(.trailing, 129)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.bottom, 41)
            }
        }
        .frame(width: width, height: statsHeight)
        .mask(RoundedRectangle(cornerRadius: 16))
        .onAppear {
            let locationWarning = !stepState.locationAlwaysAuthorized
            let motionWarning = stepState.todayStep < 0
            
            showWarning = locationWarning || motionWarning
            warningTypes = {
                if locationWarning && motionWarning {
                    return [.motion, .location]
                } else if locationWarning {
                    return [.location]
                } else if motionWarning {
                    return [.motion]
                } else {
                    return []
                }
            }()
        }
        .onTapGesture {
            Analytics.logEvent(StringLiterals.WalkieLog.mainCard, parameters: nil)
        }
    }
}

enum WarningType {
    case location
    case motion
}

struct HomeWariningView: View {
    
    let type: WarningType
    
    var body: some View {
        Button(action: {
            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }, label: {
            HStack(alignment: .center, spacing: 4) {
                Image(.icDanger)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 16, height: 16)
                
                Text(
                    type == .location
                    ? "위치 접근 권한을 '항상'으로 허용해 주세요"
                    : "동작 및 피트니스 권한을 허용해 주세요"
                )
                .font(.B2)
                .foregroundColor(.white)
            }
        })
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .background(WalkieCommonAsset.gray900.swiftUIColor.opacity(0.7))
        .cornerRadius(12, corners: .allCorners)
        .padding(.horizontal, 16)
    }
}
