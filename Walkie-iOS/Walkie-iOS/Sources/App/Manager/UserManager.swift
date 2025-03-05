//
//  UserManager.swift
//  Walkie-iOS
//
//  Created by ahra on 3/5/25.
//

import SwiftUI

final class UserManager {
    
    static let shared = UserManager()
    
    // MARK: - Properties
    
    @UserDefaultWrapper<String>(key: "userNickname") private(set) var userNickname
    
    private init() {}
}

extension UserManager {
    
    var hasUserNickname: Bool { return self.userNickname != "" }
    var getUserNickname: String { return self.userNickname ?? ""}
}

extension UserManager {
    
    func setUserNickname(_ nickname: String) {
        self.userNickname = nickname
    }
}
