//
//  MemberTarget.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/22/25.
//

import Moya

struct MemberTarget: BaseTargetType {
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

extension MemberTarget {
    static let getEggPlaying = MemberTarget(
        path: URLConstant.membersEggs,
        method: .get,
        task: .requestPlain,
        headers: APIConstants.hasTokenHeader
    )
    static func patchEggPlaying(eggId: Int) -> MemberTarget {
        return MemberTarget(
            path: URLConstant.membersEggs,
            method: .patch,
            task: .requestJSONEncodable(eggId),
            headers: APIConstants.hasTokenHeader
        )
    }
}
