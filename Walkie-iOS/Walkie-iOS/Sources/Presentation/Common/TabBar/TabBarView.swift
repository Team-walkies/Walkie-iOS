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
    @State private var tabMapView: Bool = false
    
    @StateObject var homeCoordinator: HomeCoordinator
    @StateObject var mypageCoordinator: MypageCoordinator
        
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ZStack(alignment: .bottom) {
                    
                    switch selectedTab {
                    case .home:
                        NavigationStack(path: $homeCoordinator.path) {
                            homeCoordinator.buildScene(.home)
                                .sheet(item: $homeCoordinator.appSheet) {
                                    self.homeCoordinator.buildSheet($0)
                                }
                                .fullScreenCover(item: $homeCoordinator.appFullScreenCover) {
                                    self.homeCoordinator.buildFullScreenCover($0)
                                }
                        }
                    case .mypage:
                        NavigationStack(path: $mypageCoordinator.path) {
                            mypageCoordinator.buildScene(.mypage)
                                .sheet(item: $mypageCoordinator.appSheet) {
                                    self.mypageCoordinator.buildSheet($0)
                                }
                                .fullScreenCover(item: $mypageCoordinator.appFullScreenCover) {
                                    self.mypageCoordinator.buildFullScreenCover($0)
                                }
                        }
                    case .map:
                        EmptyView()
                    }
                    
                    VStack(spacing: 0) {
                        ZStack(alignment: .bottom) {
                            Rectangle()
                                .fill(WalkieCommonAsset.gray50.swiftUIColor)
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
                                    tabMapView = true
                                },
                                label: {
                                    ZStack {
                                        Circle()
                                            .fill(WalkieCommonAsset.gray50.swiftUIColor)
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
                        
                        WalkieCommonAsset.gray50.swiftUIColor
                            .frame(height: geometry.safeAreaInsets.bottom)
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
                .navigationDestination(isPresented: $tabMapView) {
                    DIContainer.shared.buildMapView()
                        .navigationBarBackButtonHidden()
                }
            }
        }
    }
}
