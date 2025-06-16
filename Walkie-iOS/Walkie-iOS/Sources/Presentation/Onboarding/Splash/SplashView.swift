//
//  SplashView.swift
//  Walkie-iOS
//
//  Created by ahra on 2/13/25.
//

import SwiftUI

struct SplashView: View {
    
    @StateObject var splashViewModel: SplashViewModel
        
    var body: some View {
        ZStack {
            Image(.imgLogoVertical)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            splashViewModel.action(.fetchVersion)
        }
        .permissionBottomSheet(
            isPresented: $splashViewModel.showUpdateNeed,
            height: 198,
            content: {
                UpdateBSView()
            }
        )
    }
}
