//
//  MapView.swift
//  Walkie-iOS
//
//  Created by ahra on 2/24/25.
//

import SwiftUI

import WalkieCommon

struct MapView: View {
    
    @ObservedObject var viewModel: MapViewModel
    @State private var request: URLRequest?
    
    var body: some View {
        VStack(spacing: 20) {
            if let request {
                WebView(request: request, viewModel: viewModel)
                    .ignoresSafeArea(.all)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Text("웹 페이지를 불러올 수 없습니다.")
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            do {
                self.request = try viewModel.setWebURL()
            } catch {
                print("🚨 웹 URL 설정 실패: \(error)")
            }
        }
    }
}
