//
//  UpdateStepForegroundUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/30/25.
//

import Foundation
import Combine

protocol UpdateStepForegroundUseCase {
    func start() -> AnyPublisher<Int, Error>
    func stop()
}
