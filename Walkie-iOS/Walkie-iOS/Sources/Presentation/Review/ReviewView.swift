//
//  ReviewView.swift
//  Walkie-iOS
//
//  Created by ahra on 3/26/25.
//

import SwiftUI

import WalkieCommon

struct ReviewView: View {
    
    @ObservedObject var viewModel: ReviewViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel = CalendarViewModel()
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            NavigationBar(
                showBackButton: true
            )
            CalendarView(viewModel: calendarViewModel)
                .padding(.bottom, 12)
            switch viewModel.state {
            case .loaded(let reviewState):
                ScrollView {
                    HStack(spacing: 4) {
                        Text("기록")
                            .font(.B1)
                            .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
                        
                        Text("\(reviewState.count)")
                            .font(.B1)
                            .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
                        
                        Spacer()
                    }
                    .padding(.leading, 16)
                    .padding(.bottom, 12)
                    .frame(maxWidth: .infinity)
                    
                    VStack(spacing: 40) {
                        ForEach(reviewState, id: \.reviewID) { item in
                            ReviewItemView(reviewState: item)
                        }
                    }
                }
            default:
                ProgressView()
            }
        }
        .onAppear {
            viewModel.action(.calendarWillAppear)
        }
        .navigationBarBackButtonHidden()
        .bottomSheet(isPresented: $calendarViewModel.showPicker, height: 436) {
            DatePickerView(
                viewModel: DatePickerViewModel(
                    calendarViewModel: calendarViewModel,
                    selectedDate: calendarViewModel.state.selectedDate)
            )
        }
    }
}

#Preview {
    DIContainer.shared.buildReviewView()
}
