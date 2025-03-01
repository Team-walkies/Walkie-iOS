//
//  MypageMainView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 2/20/25.
//

import SwiftUI
struct MypageMainView: View {
    
    @ObservedObject var viewModel: MypageMainViewModel
    
    var body: some View {
        NavigationStack {
            switch viewModel.state {
            case .loaded(let mypageMainState):
                NavigationBar(
                    showAlarmButton: true,
                    hasAlarm: mypageMainState.hasAlarm)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        MypageMainProfileSectionView(mypageMainState: mypageMainState)
                            .padding(.bottom, 20)
                        
                        MypageMainSettingSectionView(viewModel: viewModel)
                            .padding(.bottom, 8)
                        
                        MypageMainServiceSectionView(viewModel: viewModel)
                            .padding(.bottom, 8)
                        
                        MypageMainFeedbackButtonView()
                            .padding(.bottom, 12)
                        
                        MypageMainAccountActionButtonsView(viewModel: viewModel)
                    }
                    .frame(alignment: .top)
                    .padding(.horizontal, 16)
                    .padding(.top, 4)
                }
            default:
                EmptyView()
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.action(.mypageMainWillAppear)
        }
    }
}

#Preview {
    MypageMainView(viewModel: MypageMainViewModel())
}
