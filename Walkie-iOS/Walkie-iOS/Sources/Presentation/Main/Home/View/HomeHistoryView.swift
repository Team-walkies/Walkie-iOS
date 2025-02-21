//
//  HomeHistoryView.swift
//  Walkie-iOS
//
//  Created by ahra on 2/21/25.
//

import SwiftUI

struct HomeHistoryView: View {
    
    let homeState: HomeViewModel.HomeState
    let items: [HomeHistoryItem]
    let columns = [GridItem(.flexible())]
    
    init(homeState: HomeViewModel.HomeState) {
        self.homeState = homeState
        let characterNum = homeState.characterCount
        self.items = [
            HomeHistoryItem(imageName: "img_history_egg", title: "보유한 알", count: "\(homeState.eggsCount)개"),
            HomeHistoryItem(imageName: "img_history_character", title: "부화한 캐릭터", count: "\(characterNum)마리"),
            HomeHistoryItem(imageName: "img_history_spot", title: "스팟 기록", count: "7개")
        ]
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 8) {
                Text("나의 히스토리")
                    .font(.H4)
                    .foregroundColor(.gray700)

                let width = (geometry.size.width - 48) / 3
                LazyHGrid(rows: columns) {
                    ForEach(items) { item in
                        HomeHistoryItemView(item: item, width: width)
                    }
                }
                .frame(height: 117)
            }
            .padding(.horizontal, 16)
        }
    }
}
