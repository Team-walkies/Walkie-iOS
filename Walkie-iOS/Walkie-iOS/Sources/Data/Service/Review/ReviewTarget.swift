//
//  ReviewTarget.swift
//  Walkie-iOS
//
//  Created by ahra on 3/26/25.
//

import Foundation

import Moya

struct ReviewTarget: BaseTargetType {
    
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

extension ReviewTarget {
    
    static func getReviewCalendar(date: ReviewsCalendarDate) -> ReviewTarget {
        return ReviewTarget(
            path: URLConstant.reviewCalendar,
            method: .get,
            task: .requestParameters(parameters: ["startDate": date.startDate, "endDate": date.endDate], encoding: URLEncoding.queryString),
            headers: APIConstants.hasTokenHeader
        )
    }
}
