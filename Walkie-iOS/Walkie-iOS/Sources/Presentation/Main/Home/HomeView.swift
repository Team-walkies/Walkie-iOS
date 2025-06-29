//
//  HomeView.swift
//  Walkie-iOS
//
//  Created by ahra on 2/20/25.
//

import SwiftUI

import FirebaseAnalytics

struct HomeView: View {
    
    @StateObject var viewModel: HomeViewModel
    @Environment(\.screenWidth) var screenWidth
    @Environment(\.screenHeight) var screenHeight
    @Environment(\.safeAreaBottom) private var bottomInset
    @State var navigateAlarmList: Bool = false
    
    @State private var showLocationBS: Bool = false
    @State private var showMotionBS: Bool = false
    @State private var showAlarmBS: Bool = false
    @State private var showBS: Bool = false
    
    @EnvironmentObject private var appCoordinator: AppCoordinator
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            NavigationBar(
                showLogo: true
            )
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    ZStack(alignment: .bottomTrailing) {
                        VStack {
                            let width = screenWidth - 32
                            switch (
                                viewModel.homeStatsState,
                                viewModel.stepState,
                                viewModel.homeCharacterState,
                                viewModel.leftStepState) {
                            case let (
                                .loaded(homeStatsState),
                                .loaded(stepState),
                                .loaded(characterState),
                                .loaded(leftStepState)
                            ):
                                HomeStatsView(
                                    homeStatsState: homeStatsState,
                                    stepState: stepState,
                                    leftStepState: leftStepState,
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
                                            .onTapGesture {
                                                Analytics.logEvent(
                                                    StringLiterals.WalkieLog.mainCharacter,
                                                    parameters: nil
                                                )
                                            }
                                    }
                                )
                            default:
                                HomeStatsSkeletonView()
                            }
                        }
                        .padding(.top, 8)
                    }
                    switch viewModel.homeHistoryViewState {
                    case let .loaded(homeHistoryState):
                        HomeHistoryView(
                            homeState: homeHistoryState,
                            appCoordinator: appCoordinator
                        ).padding(.top, 18)
                    default:
                        HomeHistorySkeletonView()
                    }
                }
                .padding(.bottom, 114)
            }
            .scrollIndicators(.never)
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
        .onDisappear {
            viewModel.action(.homeWillDisappear)
        }
        .onChange(of: viewModel.state) { _, newState in
            print("😇😇😇😇")
            print(newState)
            print(AppSession.shared.hasEnteredHomeView)
            if !AppSession.shared.hasEnteredHomeView {
                switch newState {
                case .loaded:
                    handlePermissionBS()
                default:
                    showBS = false
                }
            }
        }
        .onChange(of: viewModel.homeAlarmState) { _, newState in
            print("😇😇😇😇")
            print(newState)
            print(AppSession.shared.hasEnteredHomeView)
            if !AppSession.shared.hasEnteredHomeView {
                switch newState {
                case .loaded:
                    handleAlarmBS()
                default:
                    showBS = false
                }
            }
        }
        .onChange(of: viewModel.shouldShowDeniedAlert) {
            if viewModel.shouldShowDeniedAlert {
                var title: String {
                    if showLocationBS && showMotionBS {
                        return "접근권한 허용"
                    } else if showLocationBS {
                        return "위치 권한 허용"
                    } else if showMotionBS {
                        return "동작 및 피트니스 권한 허용"
                    }
                    return ""
                }
                
                var content: String {
                    if showLocationBS && showMotionBS {
                        return "원활한 서비스 이용을 위해 ‘위치’,\n‘동작 및 피트니스’ 권한을 모두 허용해 주세요"
                    } else if showLocationBS {
                        return "스팟을 탐색하기 위해 백그라운드 동작 시의\n위치 정보 접근을 허가해 주세요.\n\n1. 위치를 선택\n2. 위치 접근 허용을 ‘항상'으로 설정"
                    } else {
                        return "걸음수 측정을 위해 권한이 필요해요"
                    }
                }
                
                appCoordinator.buildAlert(
                    title: title,
                    content: content,
                    style: .primary,
                    button: .twobutton,
                    cancelButtonAction: {
                        print("😇😇cancelButtonAction😇😇")
                        viewModel.action(.homeAlarmCheck)
                    },
                    checkButtonAction: {
                        if let url = URL(string: UIApplication.openSettingsURLString)
                            , UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url)
                        }
                        print("😇😇checkButtonAction😇😇")
                        viewModel.action(.homeAlarmCheck)
                    },
                    checkButtonTitle: "허용하기"
                )
            }
        }
    }
    
    private func handlePermissionBS() {
        guard case .loaded(let state) = viewModel.state else { return }
        
        showBS = !(state.isLocationChecked.isAuthorized && state.isMotionChecked.isAuthorized)
        showLocationBS = !state.isLocationChecked.isAuthorized
        showMotionBS = !state.isMotionChecked.isAuthorized
//        showAlarmBS = !state.isAlarmChecked.isAuthorized
        
        let needsLocation = !state.isLocationChecked.isAuthorized
        let needsMotion   = !state.isMotionChecked.isAuthorized
//        let needsAlarm    = !state.isAlarmChecked.isAuthorized
        
        let isPresented = Binding<Bool>(
            get: { appCoordinator.sheet != nil },
            set: { new in
                if !new { appCoordinator.dismissSheet() }
            }
        )
        
        if needsLocation || needsMotion {
            let height = needsLocation && needsMotion ? 342 : 266
            appCoordinator.buildBottomSheet(height: CGFloat(height)) {
                HomeAuthBSView(
                    viewModel: viewModel,
                    isPresented: isPresented,
                    showLocation: needsLocation,
                    showMotion: needsMotion
                )
                .padding(.bottom, bottomInset)
            }
        } else {
            appCoordinator.dismissSheet()
        }
//        else if needsAlarm {
//            appCoordinator.buildBottomSheet(height: 369) {
//                HomeAlarmBSView(isPresented: isPresented)
//            }
//        }
        
    }
    
    private func handleAlarmBS() {
        guard case .loaded(let state) = viewModel.homeAlarmState else { return }
        
        showAlarmBS = !state.isAlarmChecked.isAuthorized
        let needsAlarm = !state.isAlarmChecked.isAuthorized
        
        let isPresented = Binding<Bool>(
            get: { appCoordinator.sheet != nil },
            set: { new in
                if !new { appCoordinator.dismissSheet() }
            }
        )
        
        if needsAlarm {
            appCoordinator.buildBottomSheet(height: 369) {
                HomeAlarmBSView(isPresented: isPresented)
                    .padding(.bottom, bottomInset)
            }
        }
    }
}
