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
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            NavigationBar(
                showLogo: true,
                showAlarmButton: true
            )
            ScrollView(.vertical) {
                VStack {
                    switch viewModel.state {
                    case .loaded(let homeState):
                        ZStack(alignment: .bottomTrailing) {
                            VStack {
                                let width = screenWidth - 32
                                HomeStatsView(homeState: homeState, width: width)
                                HomeCharacterView(homeState: homeState, width: width)
                            }
                            
                            Image(homeState.characterImage)
                                .resizable()
                                .scaledToFit()
                                .frame(
                                    width: 120,
                                    height: 120)
                                .padding(.trailing, 8)
                        }
                        .padding(.top, 8)
                        
                        HomeHistoryView(homeState: homeState)
                            .padding(.top, 18)
                    case .error(let message):
                        Text(message)
                    default:
                        ProgressView()
                    }
                }
            }
        }
        .onAppear {
            viewModel.action(.homeWillAppear)
        }
    }
}
