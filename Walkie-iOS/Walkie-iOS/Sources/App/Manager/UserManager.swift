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
    
    @UserDefaultsWrapper<String>(key: "nickname") private(set) var nickname
    
    @UserDefaultsWrapper<Bool>(key: "willHatch") private(set) var willHatch
    @UserDefaultsWrapper<EggType>(key: "eggType") private(set) var eggType
    @UserDefaultsWrapper<CharacterType>(key: "characterType") private(set) var characterType
    @UserDefaultsWrapper<JellyfishType>(key: "jellyfishType") private(set) var jellyfishType
    @UserDefaultsWrapper<DinoType>(key: "dinoType") private(set) var dinoType
    
    private init() {}
}

extension UserManager {
    
    var hasUserToken: Bool { return TokenKeychainManager.shared.hasToken() }
    var getUserNickname: String { return self.nickname ?? "" }
    var getEggType: EggType { return self.eggType ?? .normal }
    var getCharacterType: CharacterType { return self.characterType ?? .dino }
    var getJellyfishType: JellyfishType { return self.jellyfishType ?? .defaultJellyfish }
    var getDinoType: DinoType { return self.dinoType ?? .defaultDino }
}

extension UserManager {
    
    func setUserNickname(_ nickname: String) {
        self.nickname = nickname
    }
    
    func updateHatchState(_ willHatch: Bool) {
        self.willHatch = willHatch
    }
    
    func setEggType(_ eggType: EggType) {
        self.eggType = eggType
    }
    
    func setCharacterType(_ characterType: CharacterType) {
        self.characterType = characterType
    }
    
    func setJellyfishType(_ jellyfishType: JellyfishType) {
        self.jellyfishType = jellyfishType
    }
    
    func setDinoType(_ dinoType: DinoType) {
        self.dinoType = dinoType
    }
    
    func withdraw() {
        do {
            try TokenKeychainManager.shared.removeTokens()
        } catch {

        }
        nickname = nil
    }
}
