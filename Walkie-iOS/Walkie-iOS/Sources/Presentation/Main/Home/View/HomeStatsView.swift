//
//  HomeStatsView.swift
//  Walkie-iOS
//
//  Created by ahra on 2/21/25.
//

import SwiftUI

import WalkieCommon

struct HomeStatsView: View {
    
    let homeState: HomeViewModel.HomeState
    let stepState: HomeViewModel.StepState
    let width: CGFloat
    
    var body: some View {
        ZStack {
            Image(homeState.eggBackImage)
                .resizable()
                .scaledToFill()
                .frame(width: width, height: 371)
            VStack(spacing: 0) {
                HStack(alignment: .bottom, spacing: 5) {
                    Text("\(stepState.todayStep)")
                        .font(.H1)
                        .foregroundColor(.white)
                    Text("걸음")
                        .font(.B1)
                        .foregroundColor(.white)
                        .padding(.bottom, 5)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 16)
                .padding(.leading, 20)
                
                HStack(alignment: .bottom, spacing: 5) {
                    HStack(spacing: 0) {
                        let distanceStr = String(format: "%.1f", stepState.todayDistance)
                        Text(distanceStr)
                            .font(.H2)
                            .foregroundColor(.white)
                        
                        Text("km")
                            .font(.H2)
                            .foregroundColor(.white)
                    }
                    
                    Text("이동")
                        .font(.B2)
                        .foregroundColor(.white)
                        .padding(.bottom, 3)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
                
                Spacer()
                
                ZStack {
                    Image(.imgSpeechbubble)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 136, height: 45)
                    
                    HStack(spacing: 0) {
                        Text("부화까지 ")
                            .font(.B2)
                            .foregroundColor(WalkieCommonAsset.gray400.swiftUIColor)
                        
                        Text("\(stepState.leftStep)걸음")
                            .font(.B2)
                            .foregroundColor(.white)
                    }
                    .padding(.top, -8)
                }
                .padding(.bottom, -17)
                
                Image(homeState.eggImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 296, height: 296)
                    .padding(.bottom, -85)
            }
        }
        .frame(width: width, height: 371)
        .mask(RoundedRectangle(cornerRadius: 16))
    }
}
