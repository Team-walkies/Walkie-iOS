//
//  MypageMainView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 2/20/25.
//

import SwiftUI
struct MypageMainView: View {
    
    @StateObject var viewModel: MypageMainViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            NavigationBar(
            )
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    switch viewModel.state {
                    case .loaded(let mypageMainState):
                        MypageMainProfileSectionView(mypageMainState: mypageMainState)
                            .padding(.bottom, 20)
                    default:
                        MypageMainProfileSkeletonView()
                            .padding(.bottom, 20)
                    }
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
                .padding(.bottom, 114)
            }
        }
        .onAppear {
            viewModel.action(.mypageMainWillAppear)
        }
    }
}
