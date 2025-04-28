//
//  ReissueTarget.swift
//  Walkie-iOS
//
//  Created by 고아라 on 4/28/25.
//

import Moya

struct ReissueTarget: BaseTargetType {
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

extension ReissueTarget {
    
    static func reissue(refreshToken: String) -> ReissueTarget {
        ReissueTarget(
            path: URLConstant.authRefresh,
            method: .post,
            task: .requestJSONEncodable(
                [
                    "refreshToken": refreshToken
                ]
            ),
            headers: APIConstants.noTokenHeader
        )
    }
}
