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
    
    private var cancellables = Set<AnyCancellable>()
    let appCoordinator: AppCoordinator
    private let getProfileUseCase: GetProfileUseCase
    private let remoteConfigManager: RemoteConfigManaging
    @Published var showUpdateNeed: Bool = false
    
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
        getProfileUseCase: GetProfileUseCase,
        remoteConfigManager: RemoteConfigManaging = RemoteConfigManager.shared
    ) {
        self.appCoordinator = appCoordinator
        self.getProfileUseCase = getProfileUseCase
        self.remoteConfigManager = remoteConfigManager
        super.init()
        
        self.remoteConfigManager.configure(minimumFetchInterval: 0)
    }
    
    func action(_ action: Action) {
        switch action {
        case .fetchVersion:
            Task { await activateRemoteConfig() }
        }
    }
    
    private func activateRemoteConfig() async {
        do {
            try await remoteConfigManager.fetchAndActivate()
            
            let remoteVersion = remoteConfigManager
                .stringValue(for: .iOSMinAppVersion)
            let currentVersion = Bundle.main
                .infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
            
            let needsUpdate = isVersion(
                currentVersion,
                lowerThan: remoteVersion
            )
            if needsUpdate {
                await MainActor.run {
                    showUpdateNeed = true
                }
            } else {
                if TokenKeychainManager.shared.hasToken() {
                    getProfile()
                } else {
                    appCoordinator.startSplash()
                }
            }
        } catch {
            state = .error
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
