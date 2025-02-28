//
//  OnboardingView.swift
//  Walkie-iOS
//
//  Created by ahra on 2/28/25.
//

import SwiftUI

struct OnboardingView: View {
    
    let onboardingPage = OnboardingPageStruct.makeOnboardingPage()
    
    var body: some View {
        VStack(alignment: .center) {
            TabView {
                ForEach(onboardingPage, id: \.title) { item in
                    VStack(alignment: .center, spacing: 32) {
                        Image(item.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 343, height: 343)
                        
                        VStack(spacing: 12) {
                            Text(item.title)
                                .font(.H3)
                                .foregroundColor(.gray700)
                            
                            Text(item.subTitle)
                                .font(.B1)
                                .foregroundColor(.gray500)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
            }
            .onAppear { setIndicator() }
            .tabViewStyle(.page(indexDisplayMode: .always))
            
            VStack {
            }
        }
    }
    
    private func setIndicator() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.blue300)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color.gray200)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
