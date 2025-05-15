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
    
    @Environment(\.scenePhase) var scenePhase
    @State private var timer: Timer?
        
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
                        Spacer(minLength: 0)
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
                .onAppear {
                    // 포그라운드에서 Timer 시작
                    if timer == nil && scenePhase == .active {
                        startTimer()
                    }
                }
                .onDisappear {
                    // 뷰가 사라질 때 Timer 정리
                    stopTimer()
                }
                .onChange(of: scenePhase) { _, newPhase in
                    switch newPhase {
                    case .background:
                        print("---background---")
                        // 백그라운드 작업 실행
                        StepManager.shared.executeBackgroundTasks()
                        stopTimer() // 포그라운드 Timer 중지
                    case .inactive:
                        print("---inactive---")
                        stopTimer() // 비활성 상태에서 Timer 중지
                    case .active:
                        print("---active---")
                        if timer == nil {
                            startTimer() // 포그라운드에서 Timer 재시작
                        }
                    @unknown default:
                        fatalError()
                    }
                }
            }
        }
    }
    
    private func startTimer() {
        // 포그라운드에서 10초 간격으로 서버 업데이트
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
            StepManager.shared.executeForegroundTasks()
            print("포그라운드: 서버에 업데이트 완료")
        }
    }
    
    private func stopTimer() {
        // Timer 해제
        timer?.invalidate()
        timer = nil
    }
}
