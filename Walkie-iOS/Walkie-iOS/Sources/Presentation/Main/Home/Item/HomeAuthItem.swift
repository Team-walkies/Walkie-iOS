//
//  HomeAuthItem.swift
//  Walkie-iOS
//
//  Created by ahra on 4/12/25.
//

import SwiftUI

struct HomeAuthItem {
    let icon: ImageResource
    let title: String
    let subTitle: String
}

extension HomeAuthItem {
    
    static func locationAuth() -> HomeAuthItem {
        return HomeAuthItem(
            icon: .icNav,
            title: "위치",
            subTitle: "지도로 스팟 탐험하기"
        )
    }
    
    static func motionnAuth() -> HomeAuthItem {
        return HomeAuthItem(
            icon: .icMotion,
            title: "동작 및 피트니스",
            subTitle: "걸음수 측정하고 알 부화하기"
        )
    }
}
