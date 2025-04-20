//
//  TabBarCoordinator.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/20/25.
//

import SwiftUI

@Observable
final class TabBarCoordinator: Coordinator {
    var diContainer: DIContainer
    
    var path = NavigationPath()
    
    var sheet: (any AppRoute)?
    var appSheet: MypageSheet? {
        get { sheet as? MypageSheet }
        set { sheet = newValue }
    }
    var fullScreenCover: (any AppRoute)?
    var appFullScreenCover: MypageFullScreenCover? {
        get { fullScreenCover as? MypageFullScreenCover }
        set { fullScreenCover = newValue }
    }
    
    var sheetOnDismiss: (() -> Void)?
    var fullScreenCoverOnDismiss: (() -> Void)?
    
    @State var homeCoordinator: HomeCoordinator
    @State var mypageCoordinator: MypageCoordinator
    
    init(diContainer: DIContainer) {
        self.diContainer = diContainer
        self.homeCoordinator = HomeCoordinator(diContainer: diContainer)
        self.mypageCoordinator = MypageCoordinator(diContainer: diContainer)
    }
    
    @ViewBuilder
    func buildScene(_ scene: TabBarScene) -> some View {
        switch scene {
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
            diContainer.buildMapView()
        }
    }
    
    @ViewBuilder
    func buildSheet(_ sheet: TabBarSheet) -> some View {
        
    }
    
    @ViewBuilder
    func buildFullScreenCover(_ fullScreenCover: TabBarFullScreenCover) -> some View {
        
    }
    
}
