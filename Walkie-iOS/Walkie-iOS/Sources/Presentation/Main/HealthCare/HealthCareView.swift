//
//  HealthCareView.swift
//  Walkie-iOS
//
//  Created by 고아라 on 7/14/25.
//

import SwiftUI
import WalkieCommon

struct HealthCareView: View {
    
    @EnvironmentObject var appCoordinator: AppCoordinator
    @StateObject var viewModel: HealthCareViewModel
    
    var body: some View {
        VStack(
            spacing: 8
        ) {
            switch viewModel.state {
            case .loaded(let infoState):
                HealthCareInfoView(infoState: infoState)
            default:
                EmptyView()
            }
            
            switch viewModel.calorieState {
            case .loaded(let calorieState):
                HealthCareCalorieView(
                    caloriesName: calorieState.caloriesName,
                    caloriesDescription: calorieState.caloriesDescription,
                    caloriesUrl: calorieState.caloriesUrl
                )
            default:
                EmptyView()
            }
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(WalkieCommonAsset.gray50.swiftUIColor)
        .onAppear {
            viewModel.action(.viewWillAppear)
        }
    }
}
