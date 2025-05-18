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
    @State private var selectedReview: ReviewItemId?
    @State private var showReviewEdit: Bool = false
    @State private var showReviewDelete: Bool = false
    @State private var showReviewWeb: Bool = false
    
    @Environment(\.screenHeight) var screenHeight
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 0) {
                NavigationBar(
                    showBackButton: true
                )
                CalendarView(viewModel: calendarViewModel)
                ScrollView {
                    switch viewModel.state {
                    case .loaded(let reviewState):
                        HStack(spacing: 4) {
                            Text("기록")
                                .font(.B1)
                                .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
                            
                            Text("\(reviewState.count)")
                                .font(.B1)
                                .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
                            
                            Spacer()
                        }
                        .padding(.top, 12)
                        .frame(maxWidth: .infinity)
                        
                        if reviewState.count > 0 {
                            VStack(spacing: 40) {
                                ForEach(reviewState, id: \.reviewID) { item in
                                    ReviewItemView(reviewState: item) { review in
                                        selectedReview = review
                                        showReviewEdit = true
                                    }
                                }
                            }
                        } else {
                            VStack(alignment: .center) {
                                Text("해당 날짜에 기록이 없어요")
                                    .font(.B1)
                                    .foregroundColor(WalkieCommonAsset.gray400.swiftUIColor)
                                    .padding(.top, screenHeight * 170 / 812)
                            }
                        }
                    default:
                        ReviewSkeletonView()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
            }
            
            if showReviewDelete {
                Color(white: 0, opacity: 0.6)
                    .ignoresSafeArea()
                    .transition(.opacity)
                Modal(
                    title: "스팟 기록을 삭제할까요?",
                    content: "삭제된 기록은 복구할 수 없어요",
                    style: .error,
                    button: .twobutton,
                    cancelButtonAction: {
                        showReviewDelete = false
                    },
                    checkButtonAction: {
                        viewModel.action(.deleteReview(reviewId: selectedReview?.reviewId ?? -1))
                    },
                    checkButtonTitle: "삭제하기",
                    cancelButtonTitle: "뒤로가기"
                )
                .padding(.horizontal, 47)
            }
            ToastContainer()
        }
        .onAppear {
            viewModel.action(
                .loadReviewList(
                    startDate: calendarViewModel.firstDay.convertToDateString(),
                        endDate: calendarViewModel.lastDay.convertToDateString(),
                        completion: { result in
                            if result {
                                calendarViewModel.action(.didTapTodayButton)
                            }
                    }
                )
            )
        }
        .onChange(of: viewModel.delState) { _, newState in
            if case .loaded = newState {
                showReviewDelete = false
                ToastManager.shared.showToast(
                    "기록을 삭제했어요",
                    icon: .icCheckBlue
                )
            }
        }
        .onChange(of: calendarViewModel.state.selectedDate) { _, newDate in
            viewModel.action(
                .loadReviewList(
                    startDate: calendarViewModel.firstDay.convertToDateString(),
                        endDate: calendarViewModel.lastDay.convertToDateString(),
                        completion: { result in
                            if result {
                                calendarViewModel.action(.willSelectDate(newDate))
                            }
                    }
                )
            )
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
            ReviewEditView(
                onDeleteTap: {
                    showReviewEdit = false
                    showReviewDelete = true
                },
                onEditTap: {
                    showReviewEdit = false
                    showReviewWeb = true
                }
            )
        }
        .fullScreenCover(
            isPresented: $showReviewWeb,
            content: {
                ReviewWebView(
                    viewModel: viewModel,
                    reviewInfo: selectedReview ?? ReviewItemId(spotId: -1, reviewId: -1)
                )
            })
    }
}

#Preview {
    DIContainer.shared.buildReviewView()
}
