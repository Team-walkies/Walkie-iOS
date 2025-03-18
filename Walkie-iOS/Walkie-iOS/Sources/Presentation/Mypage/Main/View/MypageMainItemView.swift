//
//  MypageMainItemView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 2/21/25.
//

import SwiftUI

import WalkieCommon

struct MypageMainItemView<Item: MypageSectionItem>: View {
    let item: Item
    let viewModel: MypageMainViewModel
    var versionText: String?
    
    var body: some View {
        if item.hasNavigation {
            NavigationLink {
                item.destinationView(viewModel: viewModel)
                    .navigationBarBackButtonHidden()
            } label: {
                itemContent
            }
            .buttonStyle(PlainButtonStyle())
        } else {
            itemContent
        }
    }
    
    private var itemContent: some View {
        HStack(spacing: 0) {
            item.icon
                .frame(width: 36, height: 36)
                .padding(.trailing, 8)
            Text(item.title)
                .font(.B2)
                .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
            Spacer()
            
            if let versionInfo = versionText, !item.hasNavigation {
                Text("v\(versionInfo)")
                    .font(.B2)
                    .foregroundStyle(WalkieCommonAsset.gray400.swiftUIColor)
            } else if item.hasNavigation {
                Image(.icChevronRight)
                    .frame(width: 28, height: 28)
                    .foregroundColor(WalkieCommonAsset.gray300.swiftUIColor)
            }
        }
        .frame(height: 52)
        .contentShape(Rectangle())
    }
}
