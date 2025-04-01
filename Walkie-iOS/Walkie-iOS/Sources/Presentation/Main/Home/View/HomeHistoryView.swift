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
    let items: [HomeHistoryItem]
    let columns = [GridItem(.flexible())]
    let destination: [AnyView] = [
        AnyView(DIContainer.shared.registerEgg()),
        AnyView(DIContainer.shared.registerCharacterView()),
        AnyView(DIContainer.shared.registerReview())
    ]
    
    init(homeState: HomeViewModel.HomeHistoryState) {
        self.homeState = homeState
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
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 8) {
                Text("나의 히스토리")
                    .font(.H4)
                    .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)

                let width = (geometry.size.width - 48) / 3
                LazyHGrid(rows: columns) {
                    ForEach(items.indices, id: \.self) { index in
                        NavigationLink(destination: destination[index]) {
                            HomeHistoryItemView(item: items[index], width: width)
                        }
                    }
                }
                .frame(height: 117)
            }
            .padding(.horizontal, 16)
        }
    }
}
