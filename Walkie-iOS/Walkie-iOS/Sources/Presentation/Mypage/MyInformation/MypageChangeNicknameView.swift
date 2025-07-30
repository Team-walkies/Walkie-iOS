//
//  MypageChangeNicknameView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 7/25/25.
//

import SwiftUI
import WalkieCommon

struct MypageChangeNicknameView: View {
    
    @State private var userInput: String = ""
    @State private var isButtonEnabled: Bool = false
    @State private var inputState: InputState = .default
    @FocusState private var focused: Bool
    @ObservedObject var viewModel: MypageMyInformationViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationBar(
                rightButtonTitle: "완료",
                showBackButton: true,
                showRightButton: true,
                rightButtonEnabled: isButtonEnabled,
                rightButtonShowsEnabledColor: true,
                rightButtonAction: {
                    viewModel.action(.willChangeNickname(userInput))
                }
            )
            
            Text("새로운 닉네임을\n입력해주세요")
                .font(.H2)
                .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                .padding(.top, 24)
                .padding(.leading, 16)
            
            InputView(
                limitation: 10,
                placeholderText: viewModel.state.nickname,
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
    }
}
