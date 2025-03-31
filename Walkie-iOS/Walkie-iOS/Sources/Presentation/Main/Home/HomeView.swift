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
                    switch (viewModel.state, viewModel.stepState) {
                    case let (.loaded(homeState), .loaded(stepState)),
                        let (.error((homeState, _)), .loaded(stepState)),
                        let (.loaded(homeState), .error(stepState)),
                        let (.error((homeState, _)), .error(stepState)):
                        ZStack(alignment: .bottomTrailing) {
                            VStack {
                                let width = screenWidth - 32
                                HomeStatsView(
                                    homeState: homeState,
                                    stepState: stepState,
                                    width: width)
                                HomeCharacterView(homeState: homeState, width: width)
                            }
                            
                            Image(homeState.characterImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .padding(.trailing, 8)
                        }
                        .padding(.top, 8)
                        
                        HomeHistoryView(homeState: homeState)
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
