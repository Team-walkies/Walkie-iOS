//
//  LoginView.swift
//  Walkie-iOS
//
//  Created by ahra on 2/28/25.
//

import SwiftUI

import WalkieCommon

struct LoginView: View {
    
    @Environment(\.screenWidth) var screenWidth
    @State private var isNavigating: Bool = false
    
    private let onboardingPage = OnboardingPageStruct.makeOnboardingPage()
    
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
                                .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                            
                            Text(item.subTitle)
                                .font(.B1)
                                .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
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
                    do {
                        try TokenKeychainManager.shared.saveAccessToken("test token")
                    } catch {
                        print("토큰 저장 실패..")
                    }
                isNavigating = true
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
            .background(WalkieCommonAsset.yellow100.swiftUIColor)
            .cornerRadius(12, corners: .allCorners)
            .padding(.top, 41)
            
            Button(action: {
                print("applebutton tapped")
                isNavigating = true
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
        .navigationDestination(isPresented: $isNavigating) {
            NicknameView()
        }
    }
}

private func setIndicator() {
    UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(WalkieCommonAsset.blue300.swiftUIColor)
    UIPageControl.appearance().pageIndicatorTintColor = UIColor(WalkieCommonAsset.gray200.swiftUIColor)
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
