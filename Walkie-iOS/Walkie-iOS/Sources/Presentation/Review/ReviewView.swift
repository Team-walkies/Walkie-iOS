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
    
    init(
        viewModel: ReviewViewModel
    ) {
        self.viewModel = viewModel
        self.calendarViewModel = CalendarViewModel(reviewViewModel: viewModel)
    }
    
    var body: some View {
        ZStack {
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
            viewModel.action(.loadReviewList(
                startDate: calendarViewModel.firstDay.convertToDateString(),
                endDate: calendarViewModel.lastDay.convertToDateString()
            ))
        }
        .onChange(of: viewModel.delState) { _, newState in
            if case .loaded = newState {
                showReviewDelete = false
                ToastManager.shared.showToast(
                    "기록을 삭제했어요",
                    icon: .icCheck
                )
            }
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
                    print("show edit webview")
                }
            )
        }
    }
}

#Preview {
    DIContainer.shared.buildReviewView()
}
