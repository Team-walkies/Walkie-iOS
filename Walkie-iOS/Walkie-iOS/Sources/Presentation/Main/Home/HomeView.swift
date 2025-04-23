//
//  HomeView.swift
//  Walkie-iOS
//
//  Created by ahra on 2/20/25.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    @Environment(\.screenWidth) var screenWidth
    @Environment(\.screenHeight) var screenHeight
    @State var navigateAlarmList: Bool = false
    
    @State private var showLocationBS: Bool = false
    @State private var showMotionBS: Bool = false
    @State private var showAlarmBS: Bool = false
    @State private var showBS: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            NavigationBar(
                showLogo: true,
                showAlarmButton: true,
                rightButtonAction: {
                    navigateAlarmList = true
                }
            )
            ScrollView(.vertical) {
                VStack {
                    ZStack(alignment: .bottomTrailing) {
                        VStack {
                            let width = screenWidth - 32
                            switch (
                                viewModel.homeStatsState,
                                viewModel.stepState,
                                viewModel.homeCharacterState) {
                            case let (
                                .loaded(homeStatsState),
                                .loaded(stepState),
                                .loaded(characterState)):
                                HomeStatsView(
                                    homeStatsState: homeStatsState,
                                    stepState: stepState,
                                    width: width)
                                HomeCharacterView(
                                    homeState: characterState,
                                    width: width
                                )
                                .overlay(
                                    alignment: .bottomTrailing,
                                    content: {
                                        Image(characterState.characterImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 120, height: 120)
                                            .padding(.trailing, 8)
                                    }
                                )
                            default:
                                ProgressView()
                            }
                        }
                        .padding(.top, 8)
                    }
                    
                    switch viewModel.homeHistoryViewState {
                    case .loaded(let homeHistoryState):
                        HomeHistoryView(homeState: homeHistoryState)
                            .padding(.top, 18)
                    default:
                        ProgressView()
                    }
                }
            }
        }
        .onAppear {
            viewModel.action(.homeWillAppear)
            
            if !AppSession.shared.hasEnteredHomeView {
                AppSession.shared.hasEnteredHomeView = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    handlePermissionBS()
                }
            }
        }
        .onChange(of: viewModel.state) { _, newState in
            if !AppSession.shared.hasEnteredHomeView {
                switch newState {
                case .loaded:
                    handlePermissionBS()
                default:
                    showBS = false
                }
            }
        }
        .permissionBottomSheet(
            isPresented: $showBS,
            height: (showLocationBS && showMotionBS) ? 342 : (showAlarmBS ? 369 : 266)) {
                if showLocationBS || showMotionBS {
                    HomeAuthBSView(
                        viewModel: viewModel,
                        isPresented: $showBS,
                        showLocation: showLocationBS,
                        showMotion: showMotionBS
                    )
                } else if showAlarmBS {
                    HomeAlarmBSView(isPresented: $showBS)
                }
            }
        .overlay {
            var title: String {
                if showLocationBS && showMotionBS {
                    return "접근권한 허용"
                } else if showLocationBS {
                    return "위치 권한 허용"
                } else if showMotionBS {
                    return "신체활동 권한 허용"
                }
                return ""
            }
            
            var content: String {
                if showLocationBS && showMotionBS {
                    return "원활한 서비스 이용을 위해\n‘위치’, ‘신체활동’ 권한을 모두 허용해 주세요"
                } else if showLocationBS {
                    return "스팟을 탐색하기 위해 백그라운드 동작 시의 위치 정보 접근을 허가해 주세요.\n\n 1.위치를 선택\n2.위치 접근 허용을 ‘항상'으로 설정"
                } else {
                    return "원활한 서비스 이용을 위해 권한이 필요해요"
                }
            }
            
            if viewModel.shouldShowDeniedAlert {
                ZStack {
                    Color.black.opacity(0.6)
                        .ignoresSafeArea()
                        .transition(.opacity)
                    Modal(
                        title: title,
                        content: content,
                        style: .primary,
                        button: .twobutton,
                        cancelButtonAction: {
                            viewModel.shouldShowDeniedAlert = false
                            viewModel.getHomeAPI()
                        },
                        checkButtonAction: {
                            if let url = URL(string: UIApplication.openSettingsURLString)
                                , UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url)
                            }
                            viewModel.shouldShowDeniedAlert = false
                        },
                        checkButtonTitle: "허용하기"
                    )
                    .padding(.horizontal, 40)
                }
            }
        }
        .navigationDestination(isPresented: $navigateAlarmList) {
            DIContainer.shared.buildAlarmListView()
                .navigationBarBackButtonHidden()
        }
    }
    
    private func handlePermissionBS() {
        guard case .loaded(let state) = viewModel.state else { return }
            
        showBS = !(state.isLocationChecked.isAuthorized && state.isMotionChecked.isAuthorized)
        showLocationBS = !state.isLocationChecked.isAuthorized
        showMotionBS = !state.isMotionChecked.isAuthorized
        showAlarmBS = !state.isAlarmChecked.isAuthorized
    }
}
