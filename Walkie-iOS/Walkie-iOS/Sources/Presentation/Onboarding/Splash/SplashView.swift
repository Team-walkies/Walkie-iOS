//
//  SplashView.swift
//  Walkie-iOS
//
//  Created by ahra on 2/13/25.
//

import SwiftUI

struct SplashView: View {
        
    var body: some View {
        ZStack {
            Image(.imgLogoVertical)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
        }
        .edgesIgnoringSafeArea(.all)
    }
}
