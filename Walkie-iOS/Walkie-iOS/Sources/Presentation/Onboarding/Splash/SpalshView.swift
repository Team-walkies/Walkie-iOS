//
//  SpalshView.swift
//  Walkie-iOS
//
//  Created by ahra on 2/13/25.
//

import SwiftUI

struct SplashView: View {
    
    @Binding var showSplash: Bool
    
    var body: some View {
        ZStack {
            Image(.imgLogoVertical)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showSplash = true
                    }
                }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
