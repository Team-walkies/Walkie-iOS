//
//  DefaultWithdrawUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/5/25.
//

import Combine

final class DefaultWithdrawUseCase: BaseMemberUseCase, WithdrawUseCase {
    func execute() -> AnyPublisher<Void, NetworkError> {
        memberRepository.withdraw()
            .mapToNetworkError()
    }
}
