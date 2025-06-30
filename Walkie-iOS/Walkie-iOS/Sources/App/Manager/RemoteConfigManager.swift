//
//  RemoteConfigManager.swift
//  Walkie-iOS
//
//  Created by 고아라 on 6/30/25.
//

import FirebaseRemoteConfig

enum RemoteConfigKey: String, CaseIterable {
    case iOSMinAppVersion = "iOS_MIN_APP_VERSION"
    case eggEventEnabled = "EGG_EVENT_ENABLED"
}

protocol RemoteConfigManaging {
    func configure(minimumFetchInterval: TimeInterval)
    func fetchAndActivate() async throws
    func stringValue(for key: RemoteConfigKey) -> String
    func boolValue(for key: RemoteConfigKey) -> Bool
}

final class RemoteConfigManager: RemoteConfigManaging {
    static let shared = RemoteConfigManager()
    private let remoteConfig = RemoteConfig.remoteConfig()
    private init() {}
    
    func configure(minimumFetchInterval: TimeInterval) {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = minimumFetchInterval
        remoteConfig.configSettings = settings
    }
    
    func fetchAndActivate() async throws {
        try await remoteConfig.fetch()
        try await remoteConfig.activate()
    }
    
    func stringValue(for key: RemoteConfigKey) -> String {
        remoteConfig.configValue(forKey: key.rawValue)
            .stringValue
    }
    
    func boolValue(for key: RemoteConfigKey) -> Bool {
        remoteConfig.configValue(forKey: key.rawValue)
            .boolValue
    }
}
