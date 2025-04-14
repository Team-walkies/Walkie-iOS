//
//  HomeAuthBSView.swift
//  Walkie-iOS
//
//  Created by ahra on 4/12/25.
//

import SwiftUI

import WalkieCommon

struct HomeAuthBSView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    @Binding var isPresented: Bool
    let showLocation: Bool
    let showMotion: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .center, spacing: 4) {
                Text("워키 이용에 꼭 필요한 권한이에요!")
                    .font(.H4)
                    .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                
                Text("원활한 이용을 위해 권한을 허용해주세요")
                    .font(.B2)
                    .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
            }
            
            VStack(spacing: 8) {
                if showLocation {
                    HomeAuthItemView(item: .locationAuth())
                }
                if showMotion {
                    HomeAuthItemView(item: .motionnAuth())
                }
            }
            .padding(.horizontal, 16)
            
            CTAButton(
                title: "확인했어요",
                style: .primary,
                size: .large,
                isEnabled: true,
                buttonAction: {
                    viewModel.action(.homeAuthAllowTapped)
                    isPresented = false
                }
            )
        }
        .padding(.top, 24)
        .background(.white)
    }
}
