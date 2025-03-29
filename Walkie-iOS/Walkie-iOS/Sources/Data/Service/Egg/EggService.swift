//
//  EggService.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/22/25.
//

import Combine

protocol EggService {
    func getEggsList() -> AnyPublisher<GetEggListDto, Error>
    func getEggDetail(eggId: Int) -> AnyPublisher<GetEggDetailDto, Error>
    func patchEggStep(requestBody: PatchEggStepRequestDto) -> AnyPublisher<Void, Error>
    func getEggsCount() -> AnyPublisher<EggCountDto, Error>
}
