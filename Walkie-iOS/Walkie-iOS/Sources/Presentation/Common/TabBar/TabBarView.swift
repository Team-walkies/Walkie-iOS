//
//  TabBarView.swift
//  Walkie-iOS
//
//  Created by ahra on 2/3/25.
//

import SwiftUI

struct TabBarView: View {
    
    @StateObject private var homeViewModel = DIContainer.shared.registerHome()
    @StateObject private var mapViewModel = MapViewModel()
    @StateObject private var mypageViewModel = MypageMainViewModel()
    @State private var selectedTab: TabBarItem = .home
    
    private var viewFactory: TabTargetViewFactory {
        TabTargetViewFactory(
            homeViewModel: homeViewModel,
            mapViewModel: mapViewModel,
            mypageViewModel: mypageViewModel
        )
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                
                viewFactory.makeTargetView(for: selectedTab)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                VStack(spacing: 0) {
                    ZStack(alignment: .bottom) {
                        Rectangle()
                            .fill(.gray50)
                            .frame(height: 52)
                            .cornerRadius(20, corners: [.topLeft, .topRight])
                        
                        HStack {
                            ForEach([TabBarItem.home, TabBarItem.mypage], id: \.self) { item in
                                let isSelected = selectedTab == item
                                Button(
                                    action: {
                                        selectedTab = item
                                    },
                                    label: {
                                        VStack(spacing: 0) {
                                            (isSelected ? item.selectedItem : item.normalItem)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 24, height: 24)
                                            
                                            let color = isSelected ? item.selectedTitleColor : item.normalTitleColor
                                            Text(item.title)
                                                .font(.C2)
                                                .foregroundColor(color)
                                        }
                                    }
                                )
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .frame(height: 52)
                        
                        Button(
                            action: {
                                selectedTab = .map
                            },
                            label: {
                                ZStack {
                                    Circle()
                                        .fill(.gray50)
                                        .frame(width: 57, height: 57)
                                    
                                    TabBarItem.map.selectedItem
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 53, height: 56)
                                        .foregroundColor(.white)
                                }
                            }
                        )
                        .offset(y: -11)
                    }
                    
                    Color.gray50
                        .frame(height: geometry.safeAreaInsets.bottom)
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}
