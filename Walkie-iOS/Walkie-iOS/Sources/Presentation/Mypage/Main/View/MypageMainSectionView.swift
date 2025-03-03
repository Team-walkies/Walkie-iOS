//
//  MypageMainSectionView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 2/21/25.
//

import SwiftUI

struct MypageMainSectionView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.H6)
                .foregroundStyle(.gray500)
                .padding(.bottom, 8)
            content
        }
        .padding(.all, 16)
        .background(.gray100)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.03), radius: 10, x: 0, y: 4)
    }
}
