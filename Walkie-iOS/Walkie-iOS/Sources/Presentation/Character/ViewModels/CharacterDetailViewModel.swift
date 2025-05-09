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
        case loaded(obtainedState: [ObtainedState], detailState: CharacterDetailState)
        case error(String)
    }
    
    struct CharacterDetailState {
        let characterId: Int
        let characterName: String
        let characterImage: ImageResource
        let characterDescription: String
        let characterRank: EggType
        let characterCount: Int
        let isWalking: Bool
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
    @Published var detailState: CharacterDetailState
    @Published var obtainedState: [ObtainedState]?
    
    init(
        characterViewModel: CharacterViewModel,
        detailState: CharacterDetailState,
        getCharactersDetailUseCase: GetCharactersDetailUseCase,
        patchWalkingCharacterUseCase: PatchWalkingCharacterUseCase) {    
        self.characterViewModel = characterViewModel
        self.detailState = detailState
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
        getCharactersDetailUseCase.getCharactersObtainedDetail(characterId: detailState.characterId)
            .walkieSink(
                with: self,
                receiveValue: { _, details in
                    self.obtainedState = details.map { detail in
                        ObtainedState(
                            obtainedDate: "\(detail.obtainedDate[0]).\(detail.obtainedDate[1]).\(detail.obtainedDate[2])",
                            obtainedPosition: detail.obtainedPosition)
                    }
                    self.state = .loaded(
                        obtainedState: self.obtainedState ?? [],
                        detailState: self.detailState
                    )
                }, receiveFailure: { _, error in
                    let errorMessage = error?.description ?? "An unknown error occurred"
                    self.state = .error(errorMessage)
                }
            ).store(in: &cancellables)
    }
    
    private func patchCharacterWalking() {
        self.state = .loading
        patchWalkingCharacterUseCase.patchCharacterWalking(characterId: detailState.characterId)
            .walkieSink(
                with: self,
                receiveValue: { _, _ in
                    self.detailState = CharacterDetailState(
                        characterId: self.detailState.characterId,
                        characterName: self.detailState.characterName,
                        characterImage: self.detailState.characterImage,
                        characterDescription: self.detailState.characterDescription,
                        characterRank: self.detailState.characterRank,
                        characterCount: self.detailState.characterCount,
                        isWalking: true)
                    self.state = .loaded(
                        obtainedState: self.obtainedState ?? [],
                        detailState: self.detailState
                    )
                    self.characterViewModel.action(.fetchData)
                    ToastManager.shared.showToast("같이 걷는 캐릭터를 바꿨어요", icon: .icCheckBlue)
                }, receiveFailure: { _, error in
                    let errorMessage = error?.description ?? "An unknown error occurred"
                    self.state = .error(errorMessage)
                }
            ).store(in: &cancellables)
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
