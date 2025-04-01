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
        }
        .navigationDestination(isPresented: $navigateAlarmList) {
            DIContainer.shared.registerAlarmList()
                .navigationBarBackButtonHidden()
        }
    }
}
