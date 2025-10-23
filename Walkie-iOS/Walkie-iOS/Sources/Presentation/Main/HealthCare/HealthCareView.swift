//
//  HealthCareView.swift
//  Walkie-iOS
//
//  Created by 고아라 on 7/14/25.
//

import SwiftUI
import WalkieCommon

struct HealthCareView: View {
    
    @StateObject var viewModel: HealthCareViewModel
    @StateObject var calendarViewModel: HealthCareCalendarViewModel
    @State private var showTooltip: Bool = false
    
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
                    HealthCareInfoView(
                        infoState: infoState,
                        showTooltip: $showTooltip,
                        onTapGiveEggButton: {
                            viewModel.action(
                                .getEggButtonTapped(
                                    dateString: calendarViewModel.state.selectedDate.ymdKST
                                )
                            )
                            // TODO: 캘린더 상태 업데이트
                        }
                    )
                    .padding(.horizontal, 16)
                    .background(WalkieCommonAsset.gray50.swiftUIColor)
                default:
                    HealthCareInfoSkeletonView()
                }
                
                switch viewModel.calorieState {
                case .loaded(let calorieState):
                    HealthCareCalorieView(
                        caloriesName: calorieState.caloriesName,
                        caloriesDescription: calorieState.caloriesDescription,
                        caloriesImg: calorieState.caloriesImg
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
            .contentShape(Rectangle())
            .onTapGesture {
                showTooltip = false
            }
            .onAppear {
                viewModel.action(.viewWillAppear {
                    calendarViewModel.selectDate(Date())
                })
            }
            .onChange(of: calendarViewModel.state.selectedDate) { _, selectDate in
                showTooltip = false
                viewModel.action(.selectDateChanged(dateString: selectDate.ymdKST))
            }
        }
        .scrollIndicators(.never)
    }
}
