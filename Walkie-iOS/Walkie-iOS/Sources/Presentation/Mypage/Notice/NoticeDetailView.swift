//
//  NoticeDetailView.swift
//  Walkie-iOS
//
//  Created by ahra on 3/24/25.
//

import SwiftUI

import WalkieCommon

struct NoticeDetailView: View {
    
    @ObservedObject var viewModel: NoticeViewModel
    
    var body: some View {
        NavigationBar(
            showBackButton: true
        )
        
        ScrollView {
            switch viewModel.detailState {
            case .loaded(let detailState):
                let detail = detailState.noticeDetail
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(detail.date)
                            .font(.C1)
                            .foregroundColor(WalkieCommonAsset.gray400.swiftUIColor)
                        
                        Text(detail.title)
                            .font(.H5)
                            .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                    }
                    .padding(.top, 12)
                    .padding(.leading, 16)
                    
                    Rectangle()
                        .fill(WalkieCommonAsset.gray50.swiftUIColor)
                        .frame(height: 4)
                        .frame(maxWidth: .infinity)
                    
                    Text(detail.detail)
                        .font(.B2)
                        .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 16)
                }
                .frame(maxWidth: .infinity)
            case .error(let message):
                Text(message)
            default:
                ProgressView()
            }
        }
        .onAppear {
            viewModel.action(.noticeDetailAppear)
        }
    }
}
