//
//  HomeTarget.swift
//  Walkie-iOS
//
//  Created by ahra on 3/12/25.
//

import Foundation

import Moya

struct HomeTarget: BaseTargetType {
    
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

extension HomeTarget {
    
    static let getEggCount = HomeTarget(
        path: URLConstant.eggsCount,
        method: .get,
        task: .requestPlain,
        headers: APIConstants.hasTokenHeader
    )
}
