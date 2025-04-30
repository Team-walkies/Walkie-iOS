//
//  MypageLogoutView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/2/25.
//

import SwiftUI

struct MypageLogoutView: View {
    @ObservedObject var viewModel: MypageMainViewModel
    
    var body: some View {
        ZStack {
            if viewModel.logoutViewState.isPresented {
                Color(white: 0, opacity: 0.6)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        viewModel.logoutViewState.isPresented = false
                    }
                Modal(
                    title: "로그아웃",
                    content: "앱에서 로그아웃할까요?",
                    style: .error,
                    button: .twobutton,
                    cancelButtonAction: {
                        viewModel.logoutViewState.isPresented = false
                    },
                    checkButtonAction: {
                        viewModel.action(.logout)
                    },
                    checkButtonTitle: "로그아웃",
                    cancelButtonTitle: "뒤로가기")
                .transition(.opacity)
                .padding(.horizontal, 40)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: viewModel.logoutViewState.isPresented)
    }
}
