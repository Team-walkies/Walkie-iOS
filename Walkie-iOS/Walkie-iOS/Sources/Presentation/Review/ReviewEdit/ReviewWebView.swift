//
//  ReviewWebView.swift
//  Walkie-iOS
//
//  Created by 고아라 on 5/7/25.
//

import SwiftUI

import WalkieCommon

struct ReviewWebView: View {
    
    @ObservedObject var viewModel: ReviewViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var reviewWebRequest: URLRequest?
    var reviewInfo: ReviewItemId
    
    var body: some View {
        VStack(spacing: 20) {
            if let request = reviewWebRequest {
                WebView(
                    request: request,
                    messageHandlers: [viewModel]
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear {
            do {
                self.reviewWebRequest = try self.viewModel.setWebURL(reviewInfo: reviewInfo)
            } catch {
                print("🚨 웹 URL 설정 실패: \(error)")
            }
            viewModel.onPop = {
                dismiss()
            }
        }
        .popGestureEnabled(false)
    }
}
