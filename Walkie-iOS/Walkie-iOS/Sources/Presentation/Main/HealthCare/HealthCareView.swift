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
    @StateObject var calendarViewModel: HealthCareCalendarViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationBar(
                showBackButton: true,
                backButtonAction: {}
            )
            
            HealthCareCalendarView(viewModel: calendarViewModel)
                .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
                .padding(.bottom, 8)
                .background(WalkieCommonAsset.gray50.swiftUIColor)
            
            ScrollView(.vertical) {
                switch viewModel.state {
                case .loaded(let infoState):
                    HealthCareInfoView(infoState: infoState)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 8)
                        .background(WalkieCommonAsset.gray50.swiftUIColor)
                default:
                    HealthCareInfoSkeletonView()
                }
                
                switch viewModel.calorieState {
                case .loaded(let calorieState):
                    HealthCareCalorieView(
                        caloriesName: calorieState.caloriesName,
                        caloriesDescription: calorieState.caloriesDescription,
                        caloriesUrl: calorieState.caloriesUrl
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 50)
                    .background(WalkieCommonAsset.gray50.swiftUIColor)
                default:
                    HealthCareCalorieSkeletonView()
                        .padding(.horizontal, 16)
                        .padding(.bottom, 50)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(WalkieCommonAsset.gray50.swiftUIColor)
            .ignoresSafeArea(.all)
            .onAppear {
                calendarViewModel.selectDate(Date())
                viewModel.action(.viewWillAppear)
            }
        }
        .scrollIndicators(.never)
    }
}
