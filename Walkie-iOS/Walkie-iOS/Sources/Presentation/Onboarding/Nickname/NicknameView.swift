//
//  NicknameView.swift
//  Walkie-iOS
//
//  Created by ahra on 3/3/25.
//

import SwiftUI

import WalkieCommon

struct NicknameView: View {
    
    @State private var userInput: String = ""
    @State private var isButtonEnabled: Bool = false
    @State private var inputState: InputState = .default
    @FocusState private var focused: Bool
    @StateObject var signupViewModel: SignupViewModel
    
    @EnvironmentObject private var appCoordinator: AppCoordinator
    
    var body: some View {
        NavigationStack(path: $appCoordinator.path) {
            VStack(alignment: .leading) {
                NavigationBar(
                    rightButtonTitle: "완료",
                    showRightButton: true,
                    rightButtonEnabled: isButtonEnabled,
                    rightButtonShowsEnabledColor: true,
                    rightButtonAction: {
                        let info = LoginUserInfo(
                            provider: appCoordinator.loginInfo.provider,
                            socialToken: appCoordinator.loginInfo.socialToken,
                            username: userInput
                        )
                        signupViewModel.action(.tapSignup(info: info))
                        UserManager.shared.setUserNickname(userInput)
                    }
                )
                
                Text("워키에서 사용할\n닉네임을 지어주세요")
                    .font(.H2)
                    .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                    .padding(.top, 24)
                    .padding(.leading, 16)
                
                InputView(
                    limitation: 10,
                    placeholderText: appCoordinator.loginInfo.username == ""
                    ? "닉네임 입력"
                    : appCoordinator.loginInfo.username,
                    onlyText: true,
                    input: $userInput,
                    inputState: $inputState
                )
                .focused($focused)
                .padding(.top, 38)
                .padding(.horizontal, 16)
                .onChange(of: inputState) { _, newState in
                    isButtonEnabled = newState == .focus
                }
                
                Spacer()
            }
            .alignTo(.leading)
            .toolbar(.hidden, for: .navigationBar)
            .contentShape(Rectangle())
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.focused = true
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
            .gesture(DragGesture().onChanged { _ in
                hideKeyboard()
            })
            .onChange(of: signupViewModel.state) { _, newState in
                switch newState {
                case .loaded:
                    appCoordinator.currentScene = .complete
                default:
                    break
                }
            }
        }
    }
}
