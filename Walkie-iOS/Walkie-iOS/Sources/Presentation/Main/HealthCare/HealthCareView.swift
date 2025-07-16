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
            .frame(height: 44)
            HealthCareCalendarView(viewModel: calendarViewModel)
                .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
                .padding(.bottom, 4)
                .background(WalkieCommonAsset.gray50.swiftUIColor)
            ScrollView(.vertical) {
                switch viewModel.state {
                case .loaded(let infoState):
                    HealthCareInfoView(infoState: infoState)
                        .padding(.top, 4)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 8)
                        .background(WalkieCommonAsset.gray50.swiftUIColor)
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
                    .padding(.horizontal, 16)
                    .padding(.bottom, 50)
                    .background(WalkieCommonAsset.gray50.swiftUIColor)
                default:
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(WalkieCommonAsset.gray50.swiftUIColor)
            .ignoresSafeArea(.all)
            .onAppear {
                calendarViewModel.selectDate(Date())
                viewModel.action(.viewWillAppear)
            }
            .bottomSheet(isPresented: $calendarViewModel.state.showDatePicker, height: 436) {
                DatePickerView(
                    viewModel: DatePickerViewModel(
                        delegate: calendarViewModel,
                        selectedDate: calendarViewModel.state.selectedDate)
                )
            }
            .background(WalkieCommonAsset.gray50.swiftUIColor)
        }
        .scrollIndicators(.never)
    }
}

#Preview {
    HealthCareView(viewModel: HealthCareViewModel(), calendarViewModel: HealthCareCalendarViewModel(
        calendarUseCase: DefaultCalendarUseCase()))
    .environmentObject(AppCoordinator(diContainer: DIContainer.shared))
}
