//
//  EggViewModel.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/22/25.
//

import Combine

final class EggViewModel: ViewModelable {
    
    private let eggUseCase: EggUseCase
    private var cancellables = Set<AnyCancellable>()
    
    enum State {
        case loading
    }
    enum Action {
        
    }
    
    init(eggUseCase: EggUseCase) {
        self.eggUseCase = eggUseCase
    }
    
    @Published var state: State = .loading
    
    func action(_ action: Action) {
        
    }
}
