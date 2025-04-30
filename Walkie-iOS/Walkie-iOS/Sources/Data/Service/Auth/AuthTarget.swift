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
        headers: [String: String]? = APIConstants.hasTokenHeader
    ) {
        self.path = path
        self.method = method
        self.task = task
        self.headers = headers
    }
}

extension AuthTarget {
    
    static func login(
        request: LoginRequestDto
    ) -> AuthTarget {
        AuthTarget(
            path: URLConstant.authLogin,
            method: .post,
            task: .requestJSONEncodable(
                [
                    "provider": request.provider.rawValue,
                    "loginAccessToken": request.token
                ]
            ),
            headers: APIConstants.noTokenHeader
        )
    }
    
    static func signup(
        info: LoginUserInfo
    ) -> AuthTarget {
        AuthTarget(
            path: URLConstant.authSignup,
            method: .post,
            task: .requestJSONEncodable(
                [
                    "provider": info.provider.rawValue,
                    "loginAccessToken": info.socialToken,
                    "nickname": UserManager.shared.getUserNickname
                    
                ]
            ),
            headers: APIConstants.noTokenHeader
        )
    }
    
    static let logout: AuthTarget = AuthTarget(
        path: URLConstant.authLogout,
        method: .post,
        task: .requestPlain
    )
}
