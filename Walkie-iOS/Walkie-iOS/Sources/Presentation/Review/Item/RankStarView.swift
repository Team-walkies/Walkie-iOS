//
//  RankStarView.swift
//  Walkie-iOS
//
//  Created by ahra on 3/27/25.
//

import SwiftUI

import WalkieCommon

struct RankStarView: View {
    
    @State var rank: Int
    
    private var safeRank: Int {
        max(0, min(5, rank))
    }
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<5) { index in
                Image(index < safeRank ? .icStarFilled : .icStar)
                    .frame(width: 16, height: 16)
            }
            
            Spacer()
        }
    }
}
