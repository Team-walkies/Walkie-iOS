//
//  DefaultPatchProfileUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/5/25.
//

import Combine

final class DefaultPatchProfileUseCase: BaseMemberUseCase, PatchProfileUseCase {
    func patchProfileNickname(nickname: String) -> AnyPublisher<Void, NetworkError> {
        memberRepository.patchProfile(memberNickname: nickname)
            .mapToNetworkError()
    }
    
    func patchProfileVisibility() -> AnyPublisher<Void, NetworkError> {
        memberRepository.patchProfileVisibility()
            .mapToNetworkError()
    }
}
