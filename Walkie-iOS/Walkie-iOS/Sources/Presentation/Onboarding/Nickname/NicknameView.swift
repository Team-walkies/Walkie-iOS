//
//  NicknameView.swift
//  Walkie-iOS
//
//  Created by ahra on 3/3/25.
//

import SwiftUI

struct NicknameView: View {
    
    @State private var userInput: String = ""
    @State private var isButtonEnabled: Bool = false
    @State private var inputState: InputState = .default
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationBar(
                rightButtonTitle: "완료",
                showRightButton: true,
                rightButtonEnabled: isButtonEnabled,
                rightButtonAction: {
                    print("rightbuttontapped")
                }
            )
            
            Text("워키에서 사용할\n닉네임을 지어주세요")
                .font(.H2)
                .foregroundColor(.gray700)
                .padding(.top, 24)
                .padding(.leading, 16)
            
            InputView(
                limitation: 20,
                placeholderText: "닉네임",
                onlyText: true,
                input: $userInput,
                inputState: $inputState
            )
            .padding(.top, 38)
            .padding(.horizontal, 16)
            .onChange(of: inputState) { _, newState in
                isButtonEnabled = newState == .focus
            }
            
            Spacer()
        }
        .alignTo(.leading)
        .toolbar(.hidden, for: .navigationBar)
    }
    
}

struct NicknameView_Previews: PreviewProvider {
    static var previews: some View {
        NicknameView()
    }
}
