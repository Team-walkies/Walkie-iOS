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
    @Environment(\.screenHeight) var screenHeight
    @State private var isNavigating: Bool = false
    
    private let onboardingPage = OnboardingPageStruct.makeOnboardingPage()
    @EnvironmentObject private var appCoordinator: AppCoordinator
    @StateObject var loginViewModel: LoginViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            TabView {
                ForEach(onboardingPage, id: \.title) { item in
                    VStack(
                        alignment: .center,
                        spacing: 32
                    ) {
                        let imageSize = screenWidth - 32
                        Image(item.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: imageSize, height: imageSize)
                        
                        VStack(spacing: 12) {
                            Text(item.title)
                                .font(.H3)
                                .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                            
                            Text(item.subTitle)
                                .font(.B1)
                                .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
            }
            .onAppear { setIndicator() }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .frame(maxHeight: .infinity)
            
            Spacer()
            
            Button(action: {
                loginViewModel.action(.tapKakaoLogin)
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
                loginViewModel.action(.tapAppleLogin)
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
        .onChange(of: loginViewModel.state) { _, newState in
            switch newState {
            case .loaded(let loginState):
                appCoordinator.loginInfo = loginViewModel.loginInfo
                UserManager.shared.setUserNickname(loginViewModel.loginInfo.username)
                appCoordinator.currentScene = loginState.isExistMember ? .tabBar : .nickname
            case .error(retrySign: let retrySign):
                let content = "해당 아이디는 탈퇴 처리된 계정입니다. 자세한 사항은 이메일로 문의해 주시면 안내해 드리겠습니다. "
                let email = "\n📧 이메일: walkieofficial@gmail.com"
                if retrySign {
                    appCoordinator.presentFullScreenCover(
                        AppFullScreenCover
                            .alert(
                                title: "탈퇴 처리된 계정",
                                content: content + email,
                                style: .error,
                                button: .onebutton,
                                cancelAction: {},
                                checkAction: {},
                                checkTitle: "확인",
                                cancelTitle: ""
                            ),
                        onDismiss: {
                            loginViewModel.state = .loading
                        }
                    )
                }
            default:
                break
            }
        }
        .onAppear {
            loginViewModel.resetState()
        }
    }
}

private func setIndicator() {
    UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(WalkieCommonAsset.blue300.swiftUIColor)
    UIPageControl.appearance().pageIndicatorTintColor = UIColor(WalkieCommonAsset.gray200.swiftUIColor)
}
