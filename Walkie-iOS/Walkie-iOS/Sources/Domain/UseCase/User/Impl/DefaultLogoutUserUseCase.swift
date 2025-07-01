//
//  DefaultLogoutUserUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/20/25.
//

import Combine

final class DefaultLogoutUserUseCase: BaseUserUseCase, LogoutUserUseCase {
    
    func postLogout() -> AnyPublisher<Void, NetworkError> {
        let data = authRepository.logout()
            .mapToNetworkError()
        return data
            .handleEvents(receiveOutput: { _ in
                self.stepStatusStore.resetStepStatus()
                try? TokenKeychainManager.shared.removeTokens()
            })
            .eraseToAnyPublisher()
    }
}
