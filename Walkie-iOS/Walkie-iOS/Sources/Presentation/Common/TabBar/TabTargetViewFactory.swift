//
//  TabTargetViewFactory.swift
//  Walkie-iOS
//
//  Created by ahra on 3/9/25.
//

import SwiftUI

struct TabTargetViewFactory {
    
    @ViewBuilder
    func makeTargetView(for tab: TabBarItem, appCoordinator: AppCoordinator) -> some View {
        switch tab {
        case .home:
            DIContainer.shared.buildHomeView(appCoordinator: appCoordinator)
        case .map:
            DIContainer.shared.buildMapView()
        case .mypage:
            DIContainer.shared.buildMypageView()
        }
    }
}
