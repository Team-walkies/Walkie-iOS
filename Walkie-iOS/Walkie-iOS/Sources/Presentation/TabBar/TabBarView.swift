//
//  TabBarView.swift
//  Walkie-iOS
//
//  Created by ahra on 2/3/25.
//

import SwiftUI

struct TabBarView: View {
    @State var selectedTab: TabBarItem = .home
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.gray50)
                .frame(height: 82)
                .cornerRadius(20, corners: [.topLeft, .topRight])
            
            HStack {
                ForEach([TabBarItem.home, TabBarItem.mypage], id: \.self) { item in
                    Button(action: {
                        selectedTab = item
                    }) {
                        VStack {
                            (selectedTab == item ? item.selectedItem : item.normalItem)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                            
                            Text(item.title)
                                .font(.caption)
                                .foregroundColor(selectedTab == item ? item.selectedTitleColor : item.normalTitleColor)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 52)
            
            Button(action: {
                selectedTab = .map
            }) {
                ZStack {
                    Circle()
                        .fill(.gray50)
                        .frame(width: 57, height: 57)
                    
                    TabBarItem.map.selectedItem
                        .resizable()
                        .scaledToFit()
                        .frame(width: 53, height: 56)
                        .foregroundColor(.white)
                }
            }
            .offset(y: -30)
        }
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
            .ignoresSafeArea(edges: .bottom)
    }
}
