//
//  MemberService.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/22/25.
//

import Combine

protocol MemberService {
    
    func getEggPlaying() -> AnyPublisher<GetEggPlayingDto, Error>
    func patchEggPlaying(eggId: Int) -> AnyPublisher<Void, Error>
    func getCharacterPlay() -> AnyPublisher<CharacterPlayDto, Error>
    func patchCharacterPlay(characterId: Int) -> AnyPublisher<Void, Error>
    func getRecordedSpot() -> AnyPublisher<RecordedSpotDto, Error>
}
