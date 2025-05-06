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
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            if let request = viewModel.webRequest {
                WebView(request: request, viewModel: viewModel)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear {
            viewModel.action(.mapViewAppear)
            viewModel.onPop = {
                dismiss()
            }
        }
        .popGestureEnabled(false)
    }
}
