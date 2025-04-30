//
//  MoyaProvider+.swift
//  Walkie-iOS
//
//  Created by 고아라 on 4/28/25.
//

import Combine
import Moya
import Foundation

extension MoyaProvider {
    
    func requestPublisher(
        _ target: Target,
        reissueService: ReissueService
    ) -> AnyPublisher<Response, MoyaError> {
        self.requestPublisher(target)
            .flatMap { response -> AnyPublisher<Response, MoyaError> in
                switch response.statusCode {
                case 200..<300:
                    return Just(response)
                        .setFailureType(to: MoyaError.self)
                        .eraseToAnyPublisher()
                case 401:
                    let token = (try? TokenKeychainManager.shared.getRefreshToken()) ?? ""
                    print("refresh token: 👌👌\(token)👌👌")
                    return reissueService
                        .reissue(refreshToken: token)
                        .handleEvents(receiveOutput: { dto in
                            do {
                                print("✅ 토큰 재저장 시작함")
                                print(dto)
                                try TokenKeychainManager.shared.saveAccessToken(dto.accessToken)
                                try TokenKeychainManager.shared.saveRefreshToken(dto.refreshToken)
                                print("✅ 토큰 재저장 완료")
                            } catch {
                                print("⚠️ 토큰 저장 실패:", error)
                            }
                        })
                        .mapError { moyaError in
                            moyaError as? MoyaError ?? MoyaError.underlying(moyaError, nil)
                        }
                        .handleEvents(receiveCompletion: { completion in
                            if case .failure = completion {
                                NotificationCenter.default.post(
                                    name: .reissueFailed,
                                    object: nil
                                )
                            }
                        })
                        .flatMap { _ -> AnyPublisher<Response, MoyaError> in
                            print("👌👌재발급 완료, 원본 파이프라인으로 재요청👌👌")
                            return self.requestPublisher(target)
                        }
                        .eraseToAnyPublisher()
                default:
                    let error = MoyaError.statusCode(response)
                    return Fail(error: error).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}
