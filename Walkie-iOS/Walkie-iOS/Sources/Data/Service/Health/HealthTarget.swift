//
//  HealthTarget.swift
//  Walkie-iOS
//
//  Created by 고아라 on 8/18/25.
//

import Moya

struct HealthTarget: BaseTargetType {
    let path: String
    let method: Moya.Method
    let task: Moya.Task
    let headers: [String: String]?
    
    private init(
        path: String,
        method: Moya.Method,
        task: Moya.Task,
        headers: [String: String]? = APIConstants.hasTokenHeader
    ) {
        self.path = path
        self.method = method
        self.task = task
        self.headers = headers
    }
}

extension HealthTarget {
    
    static func health(
        param: HealthDateDto
    ) -> HealthTarget {
        HealthTarget(
            path: URLConstant.health,
            method: .get,
            task: .requestParameters(
                parameters: [
                    "startDate": param.startDate,
                    "endDate": param.endDate
                ],
                encoding: URLEncoding.queryString
            ),
            headers: APIConstants.hasTokenHeader
        )
    }
    
    static func healthDetail(
        searchDate: String
    ) -> HealthTarget {
        HealthTarget(
            path: URLConstant.healthDetail,
            method: .get,
            task: .requestParameters(
                parameters: [
                    "searchDate": searchDate
                ],
                encoding: URLEncoding.queryString
            ),
            headers: APIConstants.hasTokenHeader
        )
    }
    
    static func healthContinueDays() -> HealthTarget {
        HealthTarget(
            path: URLConstant.healthContinueDays,
            method: .get,
            task: .requestPlain,
            headers: APIConstants.hasTokenHeader
        )
    }
    
    static func healthUpdate(
        request: HealthRequestDto
    ) -> HealthTarget {
        HealthTarget(
            path: URLConstant.health,
            method: .put,
            task: .requestJSONEncodable(request),
            headers: APIConstants.hasTokenHeader
        )
    }
    
    static func healthLastDataDays() -> HealthTarget {
        HealthTarget(
            path: URLConstant.healthLastDataDays,
            method: .get,
            task: .requestPlain,
            headers: APIConstants.hasTokenHeader
        )
    }
}
