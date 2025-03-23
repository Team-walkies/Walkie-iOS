//
//  DIContainer.swift
//  Walkie-iOS
//
//  Created by ahra on 3/13/25.
//

import Foundation

final class DIContainer {
    
    static let shared = DIContainer()
    private init() {}
}

extension DIContainer {
    
    func registerHome() -> HomeViewModel {
        let homeService = DefaultHomeService()
        let homeRepo = DefaultHomeRepository(homeService: homeService)
        let homeUsecase = DefaultHomeUseCase(homeRepository: homeRepo)
        let homeVM = HomeViewModel(homeUseCase: homeUsecase)
        return homeVM
    }
    
    func registerEgg() -> EggViewModel {
        let eggService = DefaultEggService()
        let eggRepo = DefaultEggRepository(eggService: eggService)
        let eggUsecase = DefaultEggUseCase(eggRepository: eggRepo)
        let eggVM = EggViewModel(eggUseCase: eggUsecase)
        return eggVM
    }
}
