//
//  HomeHistoryView.swift
//  Walkie-iOS
//
//  Created by ahra on 2/21/25.
//

import SwiftUI

import WalkieCommon

struct HomeHistoryView: View {
    
    let homeState: HomeViewModel.HomeHistoryState
    let appCoordinator: AppCoordinator
    let items: [HomeHistoryItem]
    
    private let columns = [GridItem(.flexible())]
    @Environment(\.screenWidth) private var screenWidth
    
    init(homeState: HomeViewModel.HomeHistoryState, appCoordinator: AppCoordinator) {
        self.homeState = homeState
        self.appCoordinator = appCoordinator
        self.items = [
            HomeHistoryItem(
                imageName: "img_history_egg",
                title: "보유한 알",
                count: "\(homeState.eggsCount)개"),
            HomeHistoryItem(
                imageName: "img_history_character",
                title: "부화한 캐릭터",
                count: "\(homeState.characterCount)마리"),
            HomeHistoryItem(
                imageName: "img_history_spot",
                title: "스팟 기록",
                count: "\(homeState.spotCount)개")
        ]
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            Text("나의 히스토리")
                .font(.H4)
                .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)

            let width = (screenWidth - 48) / 3
            LazyHGrid(rows: columns) {
                ForEach(Array(HomeHistoryViewFactory.allCases.enumerated()), id: \.offset) { index, factory in
                    NavigationLink(destination: factory.buildHistoryView(appCoordinator: appCoordinator)) {
                        HomeHistoryItemView(item: items[index], width: width)
                    }
                }
            }
            .frame(height: 117)
        }
        .padding(.horizontal, 16)
    }
}
