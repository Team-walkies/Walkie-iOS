//
//  HealthCareGetEggButtonView.swift
//  Walkie-iOS
//
//  Created by 고아라 on 9/17/25.
//

import SwiftUI
import WalkieCommon

enum GetEggButtonState {
    case received
    case available
    case pending
    
    var title: String {
        switch self {
        case .received:
            return "완료"
        default:
            return "알 받기"
        }
    }
    
    var titleColor: Color {
        switch self {
        case .received:
            return WalkieCommonAsset.gray500.swiftUIColor
        case .available:
            return WalkieCommonAsset.blue400.swiftUIColor
        case .pending:
            return WalkieCommonAsset.gray400.swiftUIColor
        }
    }
}

struct HealthCareGetEggButtonView: View {
    
    let buttonState: GetEggButtonState
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            VStack(
                alignment: .center,
                spacing: 0
            ) {
                switch buttonState {
                case .received:
                    Image(.icEggReceived)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                case .available:
                    WalkieLottieView(
                        lottie: .eggButton,
                        isPlaying: true,
                        isLoop: true
                    )
                    .frame(
                        width: 40,
                        height: 40
                    )
                case .pending:
                    Image(.icEggPending)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }
                
                Text(buttonState.title)
                    .foregroundColor(buttonState.titleColor)
                    .font(.C1)
            }
        })
        .walkieTouchEffect()
    }
}
