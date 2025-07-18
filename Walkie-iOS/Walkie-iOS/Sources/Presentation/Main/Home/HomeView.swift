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
    @State private var hasShownAlarmBSOnce: Bool = false
    
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
                                viewModel.state,
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
                DispatchQueue.main.async {
                    appCoordinator.handleHomeEntry()
                }
            }
        }
        .onDisappear {
            viewModel.action(.homeWillDisappear)
        }
        .onChange(of: viewModel.eventEggState) { _, newState in
            switch newState {
            case .loaded(let eventEggState):
                if eventEggState.showEventEgg {
                    appCoordinator.buildEventAlert(
                        title: "알 1개를 선물받았어요!",
                        style: .primary,
                        button: .twobutton,
                        cancelButtonAction: { },
                        checkButtonAction: {
                            appCoordinator.push(AppScene.egg)
                        },
                        dDay: eventEggState.dDay
                    )
                }
            default:
                break
            }
        }
    }
}
