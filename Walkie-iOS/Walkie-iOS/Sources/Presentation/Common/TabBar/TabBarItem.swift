//
//  TabBarItem.swift
//  Walkie-iOS
//
//  Created by ahra on 2/3/25.
//

import SwiftUI

enum TabBarItem: CaseIterable {
    
    case home, map, mypage
    
    var title: String {
        switch self {
        case .home: return "홈"
        case .map: return ""
        case .mypage: return "마이"
        }
    }
    
    var normalTitleColor: Color {
        return .gray400
    }
    
    var selectedTitleColor: Color {
        return .gray700
    }
    
    var normalItem: Image {
        switch self {
        case .home:
            return Image(.icHomeUnselected)
        case .map:
            return Image(.icMap)
        case .mypage:
            return Image(.icMyUnselected)
        }
    }
    
    var selectedItem: Image {
        switch self {
        case .home:
            return Image(.icHomeSelected)
        case .map:
            return Image(.icMap)
        case .mypage:
            return Image(.icMySelected)
        }
    }
    
    @ViewBuilder
    var targetView: some View {
        switch self {
        case .home:
            HomeView(viewModel: HomeViewModel())
        case .map:
            MapView(viewModel: MapViewModel())
        case .mypage:
            MypageMainView(viewModel: MypageMainViewModel())
        }
    }
}
