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
    
    public init(isSmall: Bool, current: Int, total: Int) {
        self.isSmall = isSmall
        self.current = current
        self.total = total
    }
    
    public init(isSmall: Bool, current: Double, total: Double) {
        self.isSmall = isSmall
        self.current = Int(current)
        self.total = Int(total)
    }
    
    public var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundStyle(WalkieCommonAsset.gray200.swiftUIColor)
                .cornerRadius(100, corners: .allCorners)
            Rectangle()
                .foregroundStyle(WalkieCommonAsset.blue300.swiftUIColor)
                .frame(width: min(Double(current)/Double(total), 1.0) * (isSmall ? 64 : 180))
                .cornerRadius(100, corners: .allCorners)
        }.frame(width: isSmall ? 64 : 294, height: isSmall ? 4 : 8)
    }
}
