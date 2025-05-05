//
//  MypageMainView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 2/20/25.
//

import SwiftUI
struct MypageMainView: View {
    
    @ObservedObject var viewModel: MypageMainViewModel
    @State var navigateAlarmList: Bool = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                switch viewModel.state {
                case .loaded(let mypageMainState):
                    ZStack {
                        VStack(alignment: .center, spacing: 0) {
                            NavigationBar(
                            )
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
                        }
                        MypageLogoutView(viewModel: viewModel)
                    }
                default:
                    EmptyView()
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.action(.mypageMainWillAppear)
        }
    }
}
