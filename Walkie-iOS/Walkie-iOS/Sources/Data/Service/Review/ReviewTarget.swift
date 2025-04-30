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

extension ReviewTarget {
    
    static func getReviewCalendar(date: ReviewsCalendarDate) -> ReviewTarget {
        return ReviewTarget(
            path: URLConstant.reviewCalendar,
            method: .get,
            task: .requestParameters(
                parameters: ["startDate": date.startDate, "endDate": date.endDate],
                encoding: URLEncoding.queryString)
        )
    }
}
