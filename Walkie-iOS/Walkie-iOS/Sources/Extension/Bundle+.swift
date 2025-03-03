//
//  Bundle+.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/3/25.
//

import Foundation

extension Bundle {
    /// 앱 버전을 x.y.z 형식으로 불러옵니다
    var formattedAppVersion: String {
        let version = infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        var components = version.components(separatedBy: ".")
        
        while components.count < 3 {
            components.append("0")
        }
        
        return components.joined(separator: ".")
    }
}
