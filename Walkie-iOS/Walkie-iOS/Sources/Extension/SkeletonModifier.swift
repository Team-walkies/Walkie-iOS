//
//  SkeletonModifier.swift
//  Walkie-iOS
//
//  Created by 고아라 on 5/14/25.
//

import SwiftUI

struct SkeletonModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .redacted(reason: .placeholder)
            .shimmer(isGray100: true)
    }
}

struct SkeletonModifierGray200: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .redacted(reason: .placeholder)
            .shimmer(isGray100: false)
    }
}
