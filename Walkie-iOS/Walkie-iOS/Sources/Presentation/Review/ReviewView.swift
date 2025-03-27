//
//  ReviewView.swift
//  Walkie-iOS
//
//  Created by ahra on 3/26/25.
//

import SwiftUI

import WalkieCommon

struct ReviewView: View {
    
    @ObservedObject var viewModel: ReviewViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            NavigationBar(
                showBackButton: true
            )
            switch viewModel.state {
                
            case .loaded(let reviewState):
                ScrollView {
                    HStack(spacing: 4) {
                        Text("기록")
                            .font(.B1)
                            .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
                        
                        Text("\(reviewState.reviewList.count)")
                            .font(.B1)
                            .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
                        
                        Spacer()
                    }
                    .padding(.leading, 16)
                    .padding(.bottom, 12)
                    .frame(maxWidth: .infinity)
                    
                    VStack(spacing: 40) {
                        ForEach(reviewState.reviewList, id: \.reviewID) { item in
                            ReviewItemView(reviewState: item)
                        }
                    }
                }
            default:
                ProgressView()
            }
        }
        .onAppear {
            viewModel.action(.calendarWillAppear)
        }
        .navigationBarBackButtonHidden()
    }
}
