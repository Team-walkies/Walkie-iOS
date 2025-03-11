//
//  BaseTargetType.swift
//  Walkie-iOS
//
//  Created by ahra on 3/11/25.
//

import Foundation
import Moya

protocol BaseTargetType: TargetType {}

extension BaseTargetType {
    
    var baseURL: URL? {
        guard let url = URL(string: URLConstant.baseURL) else {
            print("🚨 Invalid URL 🚨")
            return nil
        }
        return url
    }
}
