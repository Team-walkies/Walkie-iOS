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
        if viewModel.logoutViewState.isPresented {
            ZStack {
                Color(white: 0, opacity: 0.6)
                Modal(
                    title: "로그아웃",
                    content: "앱에서 로그아웃할까요?",
                    style: .error,
                    button: .twobutton,
                    cancelButtonAction: {
                        viewModel.logoutViewState.isPresented.toggle()
                    },
                    checkButtonAction: {
                        viewModel.action(.logout)
                    },
                    checkButtonTitle: "로그아웃",
                    cancelButtonTitle: "뒤로가기")
            }
            .ignoresSafeArea(.all)
        }
    }
}

#Preview {
    MypageLogoutView(viewModel: MypageMainViewModel())
}
