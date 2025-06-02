//
//  MypageCoordinator.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/20/25.
//

import SwiftUI

// MARK: - 현재 사용하지 않음
@Observable
final class MypageCoordinator: Coordinator, ObservableObject {
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

    init(diContainer: DIContainer) {
        self.diContainer = diContainer
    }

    @ViewBuilder
    func buildScene(_ scene: MypageScene) -> some View {
        switch scene {
        case .mypage:
            diContainer.buildMypageView()
        case .setting(let item):
            buildSetting(item)
        case .service(let item):
            buildService(item)
        case .feedback:
            buildFeedback()
        case .withdraw:
            diContainer.buildWithdrawView()
        }
    }
    
    @ViewBuilder
    private func buildSetting(_ item: MypageSettingSectionItem) -> some View {
        let vm = diContainer.makeMypageMainViewModel()
        switch item {
        case .myInfo:
            MypageMyInformationView(viewModel: vm)
                .toolbar(.hidden, for: .tabBar)
        case .pushNotification:
            MypagePushNotificationView(viewModel: vm)
                .toolbar(.hidden, for: .tabBar)
        }
    }
    
    @ViewBuilder
    private func buildService(_ item: MypageServiceSectionItem) -> some View {
        switch item {
        case .notice:
            MypageWebView(url: MypageNotionWebViewURL.notice.url)
                .toolbar(.hidden, for: .tabBar)
        case .privacyPolicy:
            MypageWebView(url: MypageNotionWebViewURL.privacy.url)
                .toolbar(.hidden, for: .tabBar)
        case .servicePolicy:
            MypageWebView(url: MypageNotionWebViewURL.service.url)
                .toolbar(.hidden, for: .tabBar)
        case .appVersion:
            Text("앱 버전 \(Bundle.main.formattedAppVersion)")
                .toolbar(.hidden, for: .tabBar)
        }
    }
    
    @ViewBuilder
    private func buildFeedback() -> some View {
        MypageWebView(url: MypageNotionWebViewURL.questions.url)
            .toolbar(.hidden, for: .tabBar)
    }

    @ViewBuilder
    func buildSheet(_ sheet: MypageSheet) -> some View {
        
    }

    @ViewBuilder
    func buildFullScreenCover(_ fullScreenCover: MypageFullScreenCover) -> some View {
        
    }
    
}
