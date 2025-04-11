//
//  Config.swift
//  Walkie-iOS
//
//  Created by ahra on 3/11/25.
//

import Foundation

enum Config {
    
    enum Keys {
        static let baseURL = "BASE_URL"
        static let webURL = "WEB_URL"
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist cannot found.")
        }
        return dict
    }()
}

extension Config {
    
    // MARK: Base URL
    
    static let baseURL: String = {
        guard let url = Config.infoDictionary[Keys.baseURL] as? String else {
            fatalError("Base URL is not set in plist for this configuration.")
        }
        return url
    }()
    
    // MARK: Web URL
    
    static let webURL: String = {
        guard let url = Config.infoDictionary[Keys.webURL] as? String else {
            fatalError("Web URL is not set in plist for this configuration.")
        }
        return url
    }()
}
