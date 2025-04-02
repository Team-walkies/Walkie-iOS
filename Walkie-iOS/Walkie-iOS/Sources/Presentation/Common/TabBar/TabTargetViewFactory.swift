//
//  TabTargetViewFactory.swift
//  Walkie-iOS
//
//  Created by ahra on 3/9/25.
//

import SwiftUI

struct TabTargetViewFactory {
    
    @ViewBuilder
    func makeTargetView(for tab: TabBarItem) -> some View {
        switch tab {
        case .home:
            DIContainer.shared.buildHomeView()
        case .map:
            DIContainer.shared.buildMapView()
        case .mypage:
            DIContainer.shared.buildMypageView()
        }
    }
}
