//
//  MemberService.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/22/25.
//

import Combine

protocol MemberService {
    
    func getEggPlaying() -> AnyPublisher<GetEggPlayingDto, Error>
    func patchEggPlaying(eggId: Int) -> AnyPublisher<Int?, Error>
    func getCharacterPlay() -> AnyPublisher<CharacterPlayDto, Error>
}
