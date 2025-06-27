//
//  RoundedCorner.swift
//  Walkie-iOS
//
//  Created by ahra on 2/3/25.
//

import SwiftUI

public struct RoundedCorner: Shape {
    public var radius: CGFloat
    public var corners: UIRectCorner
    
    public init(radius: CGFloat = 20, corners: UIRectCorner = .allCorners) {
        self.radius = radius
        self.corners = corners
    }
    
    public func path(in rect: CGRect) -> Path {
        let topLeading = corners.contains(.topLeft) ? radius : 0
        let topTrailing = corners.contains(.topRight) ? radius : 0
        let bottomLeading = corners.contains(.bottomLeft) ? radius : 0
        let bottomTrailing = corners.contains(.bottomRight) ? radius : 0
        
        return UnevenRoundedRectangle(
            topLeadingRadius: topLeading,
            bottomLeadingRadius: bottomLeading,
            bottomTrailingRadius: bottomTrailing,
            topTrailingRadius: topTrailing
        ).path(in: rect)
    }
}
