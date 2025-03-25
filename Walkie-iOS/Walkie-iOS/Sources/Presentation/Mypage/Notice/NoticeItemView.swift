//
//  NoticeItemView.swift
//  Walkie-iOS
//
//  Created by ahra on 3/24/25.
//

import SwiftUI

import WalkieCommon

struct NoticeItemView: View {
    
    let notice: NoticeList
    let tapDetail: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(notice.title)
                    .font(.B1)
                    .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                
                Text(notice.date)
                    .font(.C1)
                    .foregroundColor(WalkieCommonAsset.gray400.swiftUIColor)
            }
            .padding(.leading, 16)
            
            Spacer()
            
            Button(action: {
                tapDetail()
            }, label: {
                Image(.icChevronRight)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .foregroundColor(WalkieCommonAsset.gray300.swiftUIColor)
            })
            .padding(.trailing, 16)
        }
        .padding(.vertical, 16)
    }
}
