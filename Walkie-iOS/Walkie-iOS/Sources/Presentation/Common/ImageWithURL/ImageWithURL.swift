//
//  ImageWithURL.swift
//  Walkie-iOS
//
//  Created by 고아라 on 6/26/25.
//

import SwiftUI
import Kingfisher

struct ImageWithURL: View {
    var url: URL
    var size: CGSize?
    
    init(
        url: URL,
        size: CGSize? = nil
    ) {
        self.url = url
        self.size = size
    }
    
    var body: some View {
        KFImage.url(url)
            .loadDiskFileSynchronously(true)
            .cacheMemoryOnly()
            .frame(
                width: size?.width,
                height: size?.height
            )
            .scaledToFit()
    }
}
