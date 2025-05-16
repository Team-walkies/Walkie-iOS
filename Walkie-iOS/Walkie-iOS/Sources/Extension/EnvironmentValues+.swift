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

private struct SafeScreenHeightKey: EnvironmentKey {
    static let defaultValue: CGFloat = {
        let fullH = UIScreen.main.bounds.height
        let window = UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .windows
            .first { $0.isKeyWindow }
        let verticalInset = (window?.safeAreaInsets.top ?? 0) + (window?.safeAreaInsets.bottom ?? 0)
        return fullH - verticalInset
    }()
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
    
    var safeScreenHeight: CGFloat {
        self[SafeScreenHeightKey.self]
    }
}
