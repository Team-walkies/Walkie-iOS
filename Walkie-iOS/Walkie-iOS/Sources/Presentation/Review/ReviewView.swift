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
    @ObservedObject var calendarViewModel: CalendarViewModel
    @State private var selectedReview: ReviewItemId? = nil
    @State private var showReviewEdit: Bool = false
    
    init(
        viewModel: ReviewViewModel
    ) {
        self.viewModel = viewModel
        self.calendarViewModel = CalendarViewModel(reviewViewModel: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            NavigationBar(
                showBackButton: true
            )
            CalendarView(viewModel: calendarViewModel)
            switch viewModel.state {
            case .loaded(let reviewState):
                ScrollView {
                    HStack(spacing: 4) {
                        Text("기록")
                            .font(.B1)
                            .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
                        
                        Text("\(reviewState?.count ?? 0)")
                            .font(.B1)
                            .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
                        
                        Spacer()
                    }
                    .padding(.top, 12)
                    .padding(.leading, 16)
                    .padding(.bottom, 12)
                    .frame(maxWidth: .infinity)
                    
                    if let reviewState {
                        VStack(spacing: 40) {
                            ForEach(reviewState, id: \.reviewID) { item in
                                ReviewItemView(reviewState: item) { review in
                                    selectedReview = review
                                    showReviewEdit = true
                                }
                            }
                        }
                    }
                }
            default:
                Spacer()
                ProgressView()
                Spacer()
            }
        }
        .onAppear {
            viewModel.action(.loadReviewList(
                startDate: calendarViewModel.firstDay.convertToDateString(),
                endDate: calendarViewModel.lastDay.convertToDateString()
            ))
        }
        .navigationBarBackButtonHidden()
        .bottomSheet(isPresented: $calendarViewModel.showPicker, height: 436) {
            DatePickerView(
                viewModel: DatePickerViewModel(
                    calendarViewModel: calendarViewModel,
                    selectedDate: calendarViewModel.state.selectedDate)
            )
        }
        .bottomSheet(isPresented: $showReviewEdit, height: 150) {
            ReviewEditView()
        }
    }
}

#Preview {
    DIContainer.shared.buildReviewView()
}
