//
//  HealthCareViewModel.swift
//  Walkie-iOS
//
//  Created by 고아라 on 7/14/25.
//

import SwiftUI

import Combine

final class HealthCareViewModel: ViewModelable {
    
    private var cancellables = Set<AnyCancellable>()
    
    enum Action {
        case viewWillAppear
    }
    
    // states
    
    struct HealthCareInfoState {
        let continuousDays: Int
        let targetSteps: TargetStep
        let nowSteps: Int
        let nowDistance: Double
        let nowCalories: Int
        let isToday: Bool
    }
    
    struct HealthCareCalorieState {
        let caloriesName: String
        let caloriesDescription: String
        let caloriesUrl: String
    }
    
    // view states
    
    enum HealthCareInfoViewState {
        case loading
        case loaded(HealthCareInfoState)
        case error
    }
    
    enum HealthCareCalorieViewState {
        case loading
        case loaded(HealthCareCalorieState)
        case error
    }
    
    @Published var state: HealthCareInfoViewState = .loading
    @Published var calorieState: HealthCareCalorieViewState = .loading
    
    func action(_ action: Action) {
        switch action {
        case .viewWillAppear:
            let st = HealthCareInfoState(
                continuousDays: 0,
                targetSteps: .six,
                nowSteps: 2515,
                nowDistance: 2.3,
                nowCalories: 340,
                isToday: true
            )
            state = .loaded(st)
            let calorieSt = HealthCareCalorieState(
                caloriesName: "바나나 1개",
                caloriesDescription: "슬슬 운동한 느낌 나죠?",
                caloriesUrl: "https://truthguard.site/api/v1/file/BANANA.png"
            )
            calorieState = .loaded(calorieSt)
        }
    }
}
