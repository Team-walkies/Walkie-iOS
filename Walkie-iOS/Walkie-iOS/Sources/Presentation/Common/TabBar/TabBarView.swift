//
//  TabBarView.swift
//  Walkie-iOS
//
//  Created by ahra on 2/3/25.
//

import SwiftUI
import WalkieCommon

struct TabBarView: View {
    
    @State private var selectedTab: TabBarItem = .home
    @EnvironmentObject var appCoordinator: AppCoordinator
    
    private let items: [TabBarItem] = [.home, .map, .mypage]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                switch selectedTab {
                case .home:
                    DIContainer.shared.buildHomeView(appCoordinator: appCoordinator)
                        .environmentObject(appCoordinator)
                case .mypage:
                    DIContainer.shared.buildMypageView(appCoordinator: appCoordinator)
                        .environmentObject(appCoordinator)
                case .map:
                    EmptyView()
                }
                
                VStack(spacing: 0) {
                    Spacer(minLength: 0)
                    ZStack(alignment: .bottom) {
                        Rectangle()
                            .fill(WalkieCommonAsset.gray50.swiftUIColor)
                            .frame(height: 52)
                            .cornerRadius(20, corners: [.topLeft, .topRight])
                        
                        HStack(
                            spacing: 0
                        ) {
                            ForEach(items.indices, id: \.self) { idx in
                                let item = items[idx]
                                let isSelected = selectedTab == item
                                let alignment: Alignment = idx == 0
                                ? .leading
                                : (idx == items.count - 1 ? .trailing : .center)
                                
                                Button(
                                    action: {
                                        if item == .map {
                                            appCoordinator.push(AppScene.map)
                                        } else {
                                            selectedTab = item
                                        }
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
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                    }
                                )
                                .frame(maxWidth: .infinity, alignment: alignment)
                                .walkieTouchEffect()
                            }
                        }
                        .padding(.horizontal, 55)
                    }
                    .frame(height: 52)
                    
                    WalkieCommonAsset.gray50.swiftUIColor
                        .frame(height: geometry.safeAreaInsets.bottom)
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .onAppear {
            appCoordinator.executeForegroundActions()
            appCoordinator.selectedTab = selectedTab
        }
        .onChange(of: selectedTab) { _, newTab in
            appCoordinator.selectedTab = newTab
        }
    }
}
