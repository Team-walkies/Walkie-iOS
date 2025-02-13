//
//  SpalshView.swift
//  Walkie-iOS
//
//  Created by ahra on 2/13/25.
//

import SwiftUI

struct SplashView: View {
    
    @State private var showHome: Bool = false
    
    var body: some View {
        if showHome {
            TabBarView()
        } else {
            Image(.imgLogoVertical)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showHome = true
                        }
                    }
                }
        }
    }
}
