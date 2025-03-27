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
    let headers: [String: String]?
    
    private init(
        path: String,
        method: Moya.Method,
        task: Moya.Task,
        headers: [String: String]?
    ) {
        self.path = path
        self.method = method
        self.task = task
        self.headers = headers
    }
}

extension EggTarget {
    static let getEggsList = EggTarget(
        path: URLConstant.eggs,
        method: .get,
        task: .requestPlain,
        headers: APIConstants.hasTokenHeader
    )
    static func patchEggStep(requestBody: PatchEggStepRequestDto) -> EggTarget {
        EggTarget(
            path: URLConstant.eggsStep,
            method: .patch,
            task: .requestJSONEncodable(requestBody),
            headers: APIConstants.hasTokenHeader
        )
    }
    static func getEggDetail(eggId: Int) -> EggTarget {
        EggTarget(
            path: URLConstant.eggsDetail(eggId: eggId),
            method: .patch,
            task: .requestPlain,
            headers: APIConstants.hasTokenHeader
        )
    }
    static let getEggsCount = EggTarget(
        path: URLConstant.eggsCount,
        method: .get,
        task: .requestPlain,
        headers: APIConstants.hasTokenHeader
    )
}
