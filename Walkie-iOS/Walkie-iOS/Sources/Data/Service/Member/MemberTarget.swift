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

extension MemberTarget {
    
    static let getEggPlaying = MemberTarget(
        path: URLConstant.membersEggs,
        method: .get,
        task: .requestPlain
    )
    
    static func patchEggPlaying(eggId: Int) -> MemberTarget {
        return MemberTarget(
            path: URLConstant.membersEggs,
            method: .patch,
            task: .requestJSONEncodable(["eggId": eggId])
        )
    }
    
    static let getCharacterPlay = MemberTarget(
        path: URLConstant.membersCharacters,
        method: .get,
        task: .requestPlain
    )
    
    static func patchCharacterPlay(characterId: Int) -> MemberTarget {
        return MemberTarget(
            path: URLConstant.membersCharacters,
            method: .patch,
            task: .requestJSONEncodable(["characterId": characterId])
        )
    }
    
    static let getRecordedSpot = MemberTarget(
        path: URLConstant.membersRecordedSpot,
        method: .get,
        task: .requestPlain
    )
    
    static func patchUserProfile(memberNickname: String) -> MemberTarget {
        MemberTarget(
            path: URLConstant.members,
            method: .post,
            task: .requestJSONEncodable(["memberNickname": memberNickname])
        )
    }
    
    static let getUserProfile = MemberTarget(
        path: URLConstant.members,
        method: .get,
        task: .requestPlain
    )
    
    static let withdraw = MemberTarget(
        path: URLConstant.members,
        method: .delete,
        task: .requestPlain
    )
    
    static let patchUserProfileVisibility = MemberTarget(
        path: URLConstant.membersProfile,
        method: .patch,
        task: .requestPlain
    )
}
