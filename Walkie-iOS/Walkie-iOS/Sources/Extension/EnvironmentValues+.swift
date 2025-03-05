//
//  EnvironmentValues+.swift
//  Walkie-iOS
//
//  Created by ahra on 3/1/25.
//

import SwiftUI

private struct ScreenWidthKey: EnvironmentKey {
    static let defaultValue: CGFloat = UIScreen.main.bounds.width
}

private struct ScreenHeightKey: EnvironmentKey {
    static let defaultValue: CGFloat = UIScreen.main.bounds.height
}

private struct DeviceRatioKey: EnvironmentKey {
    static let defaultValue: CGFloat = UIScreen.main.bounds.width / UIScreen.main.bounds.height
}

extension EnvironmentValues {
    var screenWidth: CGFloat {
        self[ScreenWidthKey.self]
    }
    
    var screenHeight: CGFloat {
        self[ScreenHeightKey.self]
    }
    
    var deviceRatio: CGFloat {
        self[DeviceRatioKey.self]
    }
}
