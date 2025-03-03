//
//  MypageMainAccountActionButtonsView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/1/25.
//

import SwiftUI

struct MypageMainAccountActionButtonsView: View {
    
    @ObservedObject var viewModel: MypageMainViewModel

    var body: some View {
        HStack(spacing: 12) {
            Button(
            action: {
                viewModel.logoutViewState.isPresented.toggle()
            }, label: {
                Text("로그아웃")
                    .font(.B2)
                    .foregroundStyle(.gray400)
            })
            
            Rectangle()
                .frame(width: 1, height: 16)
                .foregroundStyle(.gray300)
            NavigationLink(
                destination: MypageWithdrawView(viewModel: viewModel)
                    .navigationBarBackButtonHidden(),
                label: {
                Text("탈퇴하기")
                    .font(.B2)
                    .foregroundStyle(.gray400)
            }
            )
        }
        .frame(alignment: .center)
    }
}
