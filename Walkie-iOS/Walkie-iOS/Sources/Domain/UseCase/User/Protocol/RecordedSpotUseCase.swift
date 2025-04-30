//
//  RecoredSpotUseCase.swift
//  Walkie-iOS
//
//  Created by 고아라 on 4/30/25.
//

import Combine

protocol RecordedSpotUseCase {
    
    func getRecordedSpot() -> AnyPublisher<Int, NetworkError>
}
