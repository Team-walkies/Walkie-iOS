//
//  SplashViewModel.swift
//  Walkie-iOS
//
//  Created by 고아라 on 6/4/25.
//

import SwiftUI
import Combine
import FirebaseRemoteConfig

final class SplashViewModel: NSObject, ViewModelable {
    
    private let remoteConfig = RemoteConfig.remoteConfig()
    private let settings = RemoteConfigSettings()
    private var cancellables = Set<AnyCancellable>()
    let appCoordinator: AppCoordinator
    private let getProfileUseCase: GetProfileUseCase
    
    enum Action {
        case fetchVersion
    }
    
    enum SplashViewState: Equatable {
        case loading
        case loaded
        case error
    }
    
    @Published var state: SplashViewState = .loading
    
    init(
        appCoordinator: AppCoordinator,
        getProfileUseCase: GetProfileUseCase
    ) {
        self.appCoordinator = appCoordinator
        self.getProfileUseCase = getProfileUseCase
        super.init()
        
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.addOnConfigUpdateListener { [weak self] _, error in
            if error == nil {
                Task { await self?.activateRemoteConfig() }
            }
        }
    }
    
    func action(_ action: Action) {
        switch action {
        case .fetchVersion:
            Task { await activateRemoteConfig() }
        }
    }
    
    private func activateRemoteConfig() async {
        do {
            try await remoteConfig.fetch()
            try await remoteConfig.activate()
            
            let remoteVersion = remoteConfig["iOS_MIN_APP_VERSION"].stringValue
            let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
            
            let needsUpdate = isVersion(
                currentVersion,
                lowerThan: remoteVersion
            )
            if needsUpdate {
//                appCoordinator.buildAlert(
//                    title: "워키를 안전한 버전으로\n업데이트 해주세요.",
//                    content: "여러 사용성과 안전성을 업데이트 했어요.",
//                    style: .primary,
//                    button: .onebutton,
//                    cancelButtonAction: {},
//                    checkButtonAction: {
//                        self.openAppStore()
//                    },
//                    checkButtonTitle: "업데이트"
//                )
            } else {
                if TokenKeychainManager.shared.hasToken() {
                    getProfile()
                } else {
                    appCoordinator.startSplash()
                }
            }
        } catch {
            self.state = .error
        }
    }
    
    private func isVersion(_ v1: String, lowerThan v2: String) -> Bool {
        let arr1 = v1.split(separator: ".").compactMap { Int($0) }
        let arr2 = v2.split(separator: ".").compactMap { Int($0) }
        let maxCount = max(arr1.count, arr2.count)
        let nums1 = arr1 + Array(repeating: 0, count: maxCount - arr1.count)
        let nums2 = arr2 + Array(repeating: 0, count: maxCount - arr2.count)
        
        for i in 0..<maxCount {
            if nums1[i] < nums2[i] { return true }
            if nums1[i] > nums2[i] { return false }
        }
        return false
    }
    
//    func openAppStore() {
//        guard let url = URL(string: URLConstant.appStoreURL) else { return }
//        
//        if UIApplication.shared.canOpenURL(url) {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }
//    }
    
    private func getProfile() {
        getProfileUseCase.execute()
            .walkieSink(
                with: self,
                receiveValue: { _, _ in
                    self.appCoordinator.startSplash()
                }, receiveFailure: { _, error  in
                    self.appCoordinator.startSplash()
                }
            )
            .store(in: &cancellables)
    }
}
