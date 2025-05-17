//
//  MypageWebView.swift
//  Walkie-iOS
//
//  Created by 고아라 on 5/16/25.
//

import SwiftUI

struct MypageWebView: View {
    
    let url: URL?
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationBar(
                showBackButton: true
            )
            
            MypageNotionWebView(url: url)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
