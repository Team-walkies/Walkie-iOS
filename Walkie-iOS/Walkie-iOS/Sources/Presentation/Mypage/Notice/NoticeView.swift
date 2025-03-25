//
//  NoticeView.swift
//  Walkie-iOS
//
//  Created by ahra on 3/24/25.
//

import SwiftUI

import WalkieCommon

struct NoticeView: View {
    
    @ObservedObject var viewModel: NoticeViewModel
    @State private var isDetailViewActive: Bool = false
    
    var body: some View {
        VStack {
            NavigationBar(
                title: "공지사항",
                showBackButton: true
            )
            
            ScrollView {
                VStack(spacing: 0) {
                    switch viewModel.state {
                    case .loaded(let noticeState):
                        ForEach(noticeState.noticeList.noticeList, id: \.id) { item in
                            NoticeItemView(
                                notice: NoticeList(id: item.id, title: item.title, date: item.date),
                                tapDetail: {
                                    viewModel.action(.tapDetailButton(id: item.id))
                                    isDetailViewActive = true
                                }
                            )
                        }
                    case .error(let message):
                        Text(message)
                    default:
                        ProgressView()
                    }
                }
            }
        }
        .onAppear {
            viewModel.action(.noticeAppear)
        }
        .navigationDestination(isPresented: $isDetailViewActive) {
            NoticeDetailView(viewModel: viewModel)
                .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    NoticeView(viewModel: NoticeViewModel())
}
