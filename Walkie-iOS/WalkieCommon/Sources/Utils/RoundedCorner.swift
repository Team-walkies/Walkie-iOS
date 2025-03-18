//
//  RoundedCorner.swift
//  Walkie-iOS
//
//  Created by ahra on 2/3/25.
//

import SwiftUI

public struct RoundedCorner: Shape {
    public var radius: CGFloat = .infinity
    public var corners: UIRectCorner = .allCorners
    
    public func path(in rect: CGRect) -> Path {
        let size = CGSize(width: radius, height: radius)
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: size)
        
        return Path(path.cgPath)
    }
}
