//
//  RefreshTokenManager.swift
//  Walkie-iOS
//
//  Created by 고아라 on 6/9/25.
//

import Foundation
import Combine
import Moya

final class RefreshTokenManager {
    static let shared = RefreshTokenManager(service: DefaultReissueService())
    
    private let service: ReissueService
    private var refreshPublisher: AnyPublisher<ReissueDto, MoyaError>?
    private let lock = NSLock()
    
    private init(service: ReissueService) {
        self.service = service
    }
    
    func refresh() -> AnyPublisher<ReissueDto, MoyaError> {
        lock.lock(); defer { lock.unlock() }
        if let pub = refreshPublisher { return pub }
        
        let token = (try? TokenKeychainManager.shared.getRefreshToken()) ?? ""
        let pub = service
            .reissue(refreshToken: token)
            .mapError { $0 as? MoyaError ?? .underlying($0, nil) }
            .handleEvents(
                receiveOutput: { dto in
                    try? TokenKeychainManager.shared.saveAccessToken(dto.accessToken)
                    try? TokenKeychainManager.shared.saveRefreshToken(dto.refreshToken)
                },
                receiveCompletion: { completion in
                    if case .failure = completion { // 재발급 실패
                        NotificationCenter.default.post(
                            name: .reissueFailed,
                            object: nil
                        )
                    }
                    self.lock.lock()
                    self.refreshPublisher = nil
                    self.lock.unlock()
                }
            )
            .share()
            .eraseToAnyPublisher()
        
        refreshPublisher = pub
        return pub
    }
}
