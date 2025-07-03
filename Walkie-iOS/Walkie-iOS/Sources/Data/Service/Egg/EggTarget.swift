//
//  EggTarget.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/22/25.
//

import Moya

struct EggTarget: BaseTargetType {
    let path: String
    let method: Moya.Method
    let task: Moya.Task
    var headers: [String: String]? {
        APIConstants.hasTokenHeader
    }
    
    private init(
        path: String,
        method: Moya.Method,
        task: Moya.Task
    ) {
        self.path = path
        self.method = method
        self.task = task
    }
}

extension EggTarget {
    static let getEggsList = EggTarget(
        path: URLConstant.eggs,
        method: .get,
        task: .requestPlain
    )
    static func patchEggStep(requestBody: PatchEggStepRequestDto) -> EggTarget {
        EggTarget(
            path: URLConstant.eggsStep,
            method: .patch,
            task: .requestJSONEncodable(requestBody)
        )
    }
    static func getEggDetail(eggId: Int) -> EggTarget {
        EggTarget(
            path: URLConstant.eggsDetail(eggId: eggId),
            method: .get,
            task: .requestPlain
        )
    }
    static let getEggsCount = EggTarget(
        path: URLConstant.eggsCount,
        method: .get,
        task: .requestPlain
    )
    static let getEventEgg = EggTarget(
        path: URLConstant.eventsDailyEgg,
        method: .get,
        task: .requestPlain
    )
}
