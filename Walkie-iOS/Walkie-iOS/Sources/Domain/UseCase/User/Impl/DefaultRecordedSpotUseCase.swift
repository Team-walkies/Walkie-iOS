//
//  DefaultRecordedSpotUseCase.swift
//  Walkie-iOS
//
//  Created by 고아라 on 4/30/25.
//

import Combine

final class DefaultRecordedSpotUseCase: BaseMemberUseCase, RecordedSpotUseCase {
    
    func getRecordedSpot() -> AnyPublisher<Int, NetworkError> {
        memberRepository.getRecordedSpotCount()
            .mapToNetworkError()
    }
}
