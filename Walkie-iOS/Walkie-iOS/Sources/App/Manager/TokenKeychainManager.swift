//
//  TokenKeychainManager.swift
//  Walkie-iOS
//
//  Created by ahra on 3/5/25.
//

import Foundation
import Security

enum KeychainError: Error {
    case failConvertData
    case itemNotExist
    case invalidData
    case unknownError(OSStatus)
}

enum KeychainKeys {
    static let accessToken = "accessToken"
    static let refreshToken = "refreshToken"
}

final class TokenKeychainManager {
    
    static let shared = TokenKeychainManager()
    
    private init() {}
    
    // MARK: - save data
    
    func save(key: String, value: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw KeychainError.failConvertData
        }
        
        try? delete(key: key)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            throw KeychainError.unknownError(status)
        }
    }
    
    // MARK: - load data
    
    func load(key: String) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecItemNotFound {
            throw KeychainError.itemNotExist
        } else if status != errSecSuccess {
            throw KeychainError.unknownError(status)
        }
        
        guard let data = dataTypeRef as? Data, let value = String(data: data, encoding: .utf8) else {
            throw KeychainError.invalidData
        }
        return value
    }
    
    // MARK: - delete data
    
    func delete(key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            throw KeychainError.unknownError(status)
        }
    }
    
    // MARK: - accessToken
    
    func saveAccessToken(_ token: String) throws {
        try save(key: KeychainKeys.accessToken, value: token)
    }
    
    func getAccessToken() throws -> String? {
        return try load(key: KeychainKeys.accessToken)
    }
    
    // MARK: - refreshToken
    
    func saveRefreshToken(_ token: String) throws {
        try save(key: KeychainKeys.refreshToken, value: token)
    }
    
    func getRefreshToken() throws -> String? {
        return try load(key: KeychainKeys.refreshToken)
    }
    
    // MARK: - delete all tokens
    
    func removeTokens() throws {
        try delete(key: KeychainKeys.accessToken)
        try delete(key: KeychainKeys.refreshToken)
    }
    
    // MARK: - check has token
    
    func hasToken() -> Bool {
        do {
            if let accessToken = try getAccessToken(), !accessToken.isEmpty {
                return true
            }
            return false
        } catch {
            return false
        }
    }
}
