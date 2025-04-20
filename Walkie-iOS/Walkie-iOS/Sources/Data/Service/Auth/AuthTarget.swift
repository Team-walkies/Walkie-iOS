//
//  AuthTarget.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/20/25.
//

import Moya

struct AuthTarget: BaseTargetType {
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

extension AuthTarget {
    static func appleLogin(loginAccessToken: String) -> AuthTarget {
        AuthTarget(
            path: URLConstant.authLogin,
            method: .get,
            task: .requestParameters(
                parameters: ["provider": "apple", "loginAccessToken": loginAccessToken],
                encoding: URLEncoding.httpBody
            ),
            headers: APIConstants.noTokenHeader
        )
    }
    
    static func kakaoLogin(loginAccessToken: String) -> AuthTarget {
        AuthTarget(
            path: URLConstant.authLogin,
            method: .post,
            task: .requestParameters(
                parameters: ["provider": "kakao", "loginAccessToken": loginAccessToken],
                encoding: URLEncoding.httpBody
            ),
            headers: APIConstants.noTokenHeader
        )
    }
    
    static func refreshAccessToken(refreshToken: String) -> AuthTarget {
        AuthTarget(
            path: URLConstant.authToken,
            method: .post,
            task: .requestJSONEncodable(refreshToken),
            headers: APIConstants.noTokenHeader
        )
    }
    
    static let logout: AuthTarget = AuthTarget(
        path: URLConstant.authLogout,
        method: .post,
        task: .requestPlain,
        headers: APIConstants.hasTokenHeader
    )
}
