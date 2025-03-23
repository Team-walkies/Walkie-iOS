//
//  ProgressBarView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 2/10/25.
//

import SwiftUI

struct ProgressBarView: View {
    
    var isSmall: Bool
    var current: Int
    var total: Int
    
    init(isSmall: Bool, current: Int, total: Int) {
        self.isSmall = isSmall
        self.current = current
        self.total = total
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundStyle(.gray200)
                .cornerRadius(100, corners: .allCorners)
            Rectangle()
                .foregroundStyle(.blue300)
                .frame(width: min(Double(current)/Double(total), 1.0) * (isSmall ? 64 : 180))
                .cornerRadius(100, corners: .allCorners)
        }.frame(width: isSmall ? 64 : 180, height: isSmall ? 4 : 8)
    }
}
