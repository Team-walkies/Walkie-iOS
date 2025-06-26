//
//  CharacterDetailViewModel.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/28/25.
//

import Combine
import SwiftUI

final class CharacterDetailViewModel: ViewModelable {
    
    @ObservedObject var characterViewModel: CharacterViewModel
    private let getCharactersDetailUseCase: GetCharactersDetailUseCase
    private let patchWalkingCharacterUseCase: PatchWalkingCharacterUseCase
    private var cancellables = Set<AnyCancellable>()
    
    enum CharacterDetailViewState {
        case loading
        case loaded(CharacterDetailState)
        case error(String)
    }
    
    struct CharacterInfo {
        let characterId: Int
        let isWalking: Bool
    }
    
    struct CharacterDetailState {
        let characterId: Int
        let characterName: String
        let characterImage: ImageResource
        let characterDescription: String
        let characterRank: EggType
        let characterCount: Int
        var isWalking: Bool
        let obtainedState: [ObtainedState]
    }
    
    struct ObtainedState: Identifiable {
        let id = UUID()
        let obtainedDate: String
        let obtainedPosition: String
    }
    
    enum Action {
        case willAppear
        case didSelectCharacterWalking
    }
    
    @Published var state: CharacterDetailViewState = .loading
    @Published var characterInfo: CharacterInfo
    
    init(
        characterViewModel: CharacterViewModel,
        characterInfo: CharacterInfo,
        getCharactersDetailUseCase: GetCharactersDetailUseCase,
        patchWalkingCharacterUseCase: PatchWalkingCharacterUseCase
    ) {
        self.characterViewModel = characterViewModel
        self.characterInfo = characterInfo
        self.getCharactersDetailUseCase = getCharactersDetailUseCase
        self.patchWalkingCharacterUseCase = patchWalkingCharacterUseCase
    }
    
    func action(_ action: Action) {
        switch action {
        case .willAppear:
            fetchCharacterDetailData()
        case .didSelectCharacterWalking:
            patchCharacterWalking()
        }
    }
    
    private func fetchCharacterDetailData() {
        getCharactersDetailUseCase
            .getCharactersObtainedDetail(
                characterId: characterInfo.characterId
            )
            .walkieSink(
                with: self,
                receiveValue: { _, details in
                    let state = CharacterDetailState(
                        characterId: self.characterInfo.characterId,
                        characterName: details.name,
                        characterImage: .imgJellyfish0,
                        characterDescription: details.description,
                        characterRank: details.rank,
                        characterCount: details.count,
                        isWalking: self.characterInfo.isWalking,
                        obtainedState: details.obtainEntity.map { detail in
                            ObtainedState(
                                obtainedDate: self.convertDateFormat(
                                    from: detail.obtainedDate
                                ) ?? "날짜 변환 오류",
                                obtainedPosition: detail.obtainedPosition)
                        }
                    )
                    self.state = .loaded(state)
                }, receiveFailure: { _, error in
                    let errorMessage = error?.description ?? "An unknown error occurred"
                    self.state = .error(errorMessage)
                }
            )
            .store(in: &cancellables)
    }
    
    private func patchCharacterWalking() {
        patchWalkingCharacterUseCase
            .patchCharacterWalking(
                characterId: characterInfo.characterId
            )
            .walkieSink(
                with: self,
                receiveValue: { _, _ in
                    if case .loaded(var detail) = self.state {
                        detail.isWalking = true
                        self.state = .loaded(detail)
                    }
                    self.characterViewModel.action(.fetchData)
                    ToastManager.shared.showToast("같이 걷는 캐릭터를 바꿨어요", icon: .icCheckBlue)
                }, receiveFailure: { _, error in
                    let errorMessage = error?.description ?? "An unknown error occurred"
                    self.state = .error(errorMessage)
                }
            )
            .store(in: &cancellables)
    }
}

extension CharacterDetailViewModel {
    private func convertDateFormat(from input: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy.MM.dd."
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = inputFormatter.date(from: input) {
            return outputFormatter.string(from: date)
        } else {
            return nil
        }
    }
}
