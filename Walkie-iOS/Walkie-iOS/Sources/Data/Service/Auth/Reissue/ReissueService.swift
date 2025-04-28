//
//  ReissueService.swift
//  Walkie-iOS
//
//  Created by 고아라 on 4/28/25.
//

import Combine

protocol ReissueService {
    func reissue(refreshToken: String) -> AnyPublisher<ReissueDto, Error>
}
