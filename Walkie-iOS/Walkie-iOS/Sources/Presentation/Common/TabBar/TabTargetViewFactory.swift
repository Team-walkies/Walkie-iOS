//
//  TabTargetViewFactory.swift
//  Walkie-iOS
//
//  Created by ahra on 3/9/25.
//

import SwiftUI

struct TabTargetViewFactory {
    
    let homeViewModel: HomeViewModel
    let mapViewModel: MapViewModel
    let mypageViewModel: MypageMainViewModel
    
    @ViewBuilder
    func makeTargetView(for tab: TabBarItem) -> some View {
        switch tab {
        case .home:
            HomeView(viewModel: homeViewModel)
        case .map:
            MapView(viewModel: mapViewModel)
        case .mypage:
            MypageMainView(viewModel: mypageViewModel)
        }
    }
}
