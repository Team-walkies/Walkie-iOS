//
//  HomeView.swift
//  Walkie-iOS
//
//  Created by ahra on 2/20/25.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                NavigationBar(
                    showLogo: true,
                    showAlarmButton: true
                )
                
                switch viewModel.state {
                case .loaded(let homeState):
                    ZStack(alignment: .bottomTrailing) {
                        VStack {
                            let width = geometry.size.width - 32
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
                    
                default:
                    EmptyView()
                }
            }
        }
        .onAppear {
            viewModel.action(.homeWillAppear)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
