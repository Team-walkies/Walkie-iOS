//
//  ToastView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 2/12/25.
//

import SwiftUI

struct ToastView: View {
    let message: String
    let icon: UIImage?

    var body: some View {
        HStack {
            if let icon {
                Image(uiImage: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .padding(.trailing, 8)
            }
            Text(message)
                .font(.B2)
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.gray700)
        .cornerRadius(12)
    }
}
