//
//  ProgressBarView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 2/10/25.
//

import SwiftUI

public struct ProgressBarView: View {
    
    var isSmall: Bool
    var current: Int
    var total: Int
    var isDynamicIsland: Bool
    var isLiveActivity: Bool = false
    
    public init(
        isSmall: Bool,
        current: Int,
        total: Int,
        isDynamicIsland: Bool = false
    ) {
        self.isSmall = isSmall
        self.current = current
        self.total = total
        self.isDynamicIsland = isDynamicIsland
    }
    
    public init(
        isSmall: Bool,
        current: Double,
        total: Double,
        isDynamicIsland: Bool = false,
        isLiveActivity: Bool
    ) {
        self.isSmall = isSmall
        self.current = Int(current)
        self.total = Int(total)
        self.isDynamicIsland = isDynamicIsland
        self.isLiveActivity = isLiveActivity
    }
    
    public var body: some View {
        let width: CGFloat = isDynamicIsland ? 294 : (isSmall ? 64 : 180)
        let backColor = isLiveActivity ? WalkieCommonAsset.gray400.swiftUIColor : (isDynamicIsland ? WalkieCommonAsset.gray800.swiftUIColor : WalkieCommonAsset.gray200.swiftUIColor)
        let progressColor = isLiveActivity ? WalkieCommonAsset.gray600.swiftUIColor : WalkieCommonAsset.blue300.swiftUIColor
        
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundStyle(backColor)
                .cornerRadius(100, corners: .allCorners)
            Rectangle()
                .foregroundStyle(progressColor)
                .frame(width: min(Double(current)/Double(total), 1.0) * (isSmall ? 64 : width))
                .cornerRadius(100, corners: .allCorners)
        }
        .frame(width: isSmall ? 64 : width, height: isSmall ? 4 : 8)
    }
}
