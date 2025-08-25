//
//  GetHealthLastDataDayUseCase.swift
//  Walkie-iOS
//
//  Created by 고아라 on 8/25/25.
//

import Combine
import Foundation

protocol GetHealthLastDataDayUseCase {
    func getHealthLastDataDay() -> AnyPublisher<Date, NetworkError>
}
