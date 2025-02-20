//
//  HomeHistoryItemView.swift
//  Walkie-iOS
//
//  Created by ahra on 2/21/25.
//

import SwiftUI

struct HomeHistoryItemView: View {

    let item: HomeHistoryItem
    
    var body: some View {
        VStack(spacing: 8) {
            Image(item.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 109, height: 69)
            
            VStack(spacing: 0) {
                Text(item.title)
                    .font(.H6)
                    .foregroundColor(.gray700)
                
                Text(item.count)
                    .font(.B2)
                    .foregroundColor(.gray500)
            }
        }
    }
}
