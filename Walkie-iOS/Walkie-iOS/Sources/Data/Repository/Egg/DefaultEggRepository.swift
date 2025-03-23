//
//  DefaultEggRepository.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/22/25.
//

import Combine

final class DefaultEggRepository {
    
    // MARK: - Dependency
    
    private let eggService: EggService
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(eggService: EggService) {
        self.eggService = eggService
    }
}

extension DefaultEggRepository: EggRepository {
    
    func getEggsList() -> AnyPublisher<GetEggListDto, Error> {
        eggService.getEggsList()
            .eraseToAnyPublisher()
    }
    
    func getEggDetail(eggId: Int) -> AnyPublisher<GetEggDetailDto, Error> {
        eggService.getEggDetail(eggId: eggId)
            .eraseToAnyPublisher()
    }
    
    func patchEggStep(requestBody: PatchEggStepRequestDto) -> AnyPublisher<Int?, Error> {
        eggService.patchEggStep(requestBody: requestBody)
            .eraseToAnyPublisher()
    }
    
    func getEggsCount() -> AnyPublisher<EggCountDto, Error> {
        eggService.getEggsCount()
            .eraseToAnyPublisher()
    }
}
