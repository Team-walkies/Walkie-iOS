//
//  ProgressBarView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 2/10/25.
//

import SwiftUI

public struct ProgressBarView: View {
    
    public var isSmall: Bool
    public var current: Double
    public var total: Double
    
    public init(isSmall: Bool, current: Double, total: Double) {
        self.isSmall = isSmall
        self.current = current
        self.total = total
    }
    
    public var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundStyle(WalkieCommonAsset.gray800.swiftUIColor)
                .cornerRadius(100, corners: .allCorners)
            Rectangle()
                .foregroundStyle(WalkieCommonAsset.blue300.swiftUIColor)
                .frame(width: current/total*(isSmall ? 64 : 180))
                .cornerRadius(100, corners: .allCorners)
        }
        .frame(width: isSmall ? 64 : 294, height: isSmall ? 4 : 8)
    }
}
