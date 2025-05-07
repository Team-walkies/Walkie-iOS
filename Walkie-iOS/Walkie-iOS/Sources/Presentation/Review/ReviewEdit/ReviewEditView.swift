//
//  ReviewEditView.swift
//  Walkie-iOS
//
//  Created by 고아라 on 5/7/25.
//

import SwiftUI

import WalkieCommon

struct ReviewEditView: View {
    
    @Environment(\.screenWidth) var screenWidth
    
    var body: some View {
        HStack(spacing: 8) {
            Button(action: {
                print("show delete alert")
            }, label: {
                VStack(alignment: .center, spacing: 4) {
                    Image(.icDelete)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(WalkieCommonAsset.red100.swiftUIColor)
                    
                    Text("삭제하기")
                        .font(.B2)
                        .foregroundColor(WalkieCommonAsset.red100.swiftUIColor)
                }
                .frame(width: (screenWidth - 40) / 2, height: 72)
            })
            .background(WalkieCommonAsset.gray50.swiftUIColor)
            .cornerRadius(12, corners: .allCorners)
            
            Button(action: {
                print("show edit webview")
            }, label: {
                VStack(alignment: .center, spacing: 4) {
                    Image(.icEdit)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
                    
                    Text("수정하기")
                        .font(.B2)
                        .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                }
                .frame(width: (screenWidth - 40) / 2, height: 72)
            })
            .background(WalkieCommonAsset.gray50.swiftUIColor)
            .cornerRadius(12, corners: .allCorners)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
    }
}
