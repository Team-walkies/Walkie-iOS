//
//  LoginView.swift
//  Walkie-iOS
//
//  Created by ahra on 2/28/25.
//

import SwiftUI

struct LoginView: View {
    
    @Environment(\.screenWidth) var screenWidth
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
                        Spacer()
                    }
                }
            }
            .onAppear { setIndicator() }
            .tabViewStyle(.page(indexDisplayMode: .always))
            
            Spacer()
            
            Button(action: {
                print("kakaobutton tapped")
            }, label: {
                HStack(spacing: 8) {
                    Image(.icKakao)
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    
                    Text("카카오 계정으로 계속하기")
                        .font(.B1)
                        .foregroundColor(.black)
                }
            })
            .frame(width: screenWidth - 32, height: 54)
            .background(.yellow100)
            .cornerRadius(12, corners: .allCorners)
            .padding(.top, 41)
            
            Button(action: {
                print("applebutton tapped")
            }, label: {
                HStack(spacing: 8) {
                    Image(.icApple)
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    
                    Text("Apple로 시작하기")
                        .font(.B1)
                        .foregroundColor(.white)
                }
            })
            .frame(width: screenWidth - 32, height: 54)
            .background(.black)
            .cornerRadius(12, corners: .allCorners)
            .padding(.bottom, 4)
        }
    }
    
    private func setIndicator() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.blue300)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color.gray200)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
