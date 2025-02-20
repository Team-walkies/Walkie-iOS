//
//  HomeCharacterView.swift
//  Walkie-iOS
//
//  Created by ahra on 2/21/25.
//

import SwiftUI

struct HomeCharacterView: View {
    
    let homeState: HomeViewModel.HomeState
    let width: CGFloat
    
    var body: some View {
        HStack {
            HStack(spacing: 0) {
                Text(homeState.characterName)
                    .font(.H6)
                    .foregroundColor(.gray700)
                
                Text("와 함께 걷는 중..")
                    .font(.B2)
                    .foregroundColor(.gray500)
            }
            .padding(.leading, 16)
            Spacer()
        }
        .frame(
            width: width,
            height: 52
        )
        .background(.gray100)
        .mask(RoundedRectangle(cornerRadius: 12))
        
    }
}
