//
//  GetTodayStepUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 10/5/25.
//

import Foundation

public protocol GetTodayStepUseCase {
    func execute(completion: @escaping (Result<Int, Error>) -> Void)
}
