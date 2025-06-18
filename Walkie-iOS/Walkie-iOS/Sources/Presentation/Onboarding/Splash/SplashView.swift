//
//  SplashView.swift
//  Walkie-iOS
//
//  Created by ahra on 2/13/25.
//

import SwiftUI

struct SplashView: View {
    
    @StateObject var splashViewModel: SplashViewModel
    @EnvironmentObject var appCoordinator: AppCoordinator
        
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
        .onChange(of: splashViewModel.showUpdateNeed) { _, new in
            guard new else { return }
            withAnimation {
                appCoordinator.buildBottomSheet(height: 198) {
                    UpdateBSView()
                        .background(Color.white)
                }
            }
        }
    }
}
