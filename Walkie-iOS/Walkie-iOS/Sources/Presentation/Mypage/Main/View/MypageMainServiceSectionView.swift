//
//  MypageMainServiceSectionView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 2/21/25.
//

import SwiftUI

struct MypageMainServiceSectionView: View {
    
    @ObservedObject var viewModel: MypageMainViewModel
    
    var body: some View {
        MypageMainSectionView(title: MypageItem.service.title) {
            ForEach([
                MypageServiceSectionItem.notice,
                MypageServiceSectionItem.privacyPolicy,
                MypageServiceSectionItem.servicePolicy,
                MypageServiceSectionItem.appVersion
            ], id: \.title) { item in
                MypageMainItemView(
                    item: item,
                    viewModel: viewModel,
                    versionText: (item == .appVersion)
                    ? Bundle.main.formattedAppVersion
                    : nil)
            }
        }
    }
}
