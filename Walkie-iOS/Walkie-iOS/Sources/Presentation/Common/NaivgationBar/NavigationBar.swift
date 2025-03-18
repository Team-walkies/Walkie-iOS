//
//  NavigationBar.swift
//  Walkie-iOS
//
//  Created by ahra on 2/10/25.
//

import SwiftUI

import WalkieCommon

struct NavigationBar: View {
    
    // MARK: - Properties
    
    private let title: String?
    private let rightButtonTitle: String?
    private let showLogo: Bool
    private let showBackButton: Bool
    private let showRightButton: Bool
    private let showAlarmButton: Bool
    private let hasAlarm: Bool
    private let rightButtonEnabled: Bool
    private let backButtonAction: () -> Void
    private let rightButtonAction: () -> Void
    
    // MARK: - Initialization
    
    init(
        title: String? = nil,
        rightButtonTitle: String? = nil,
        showLogo: Bool = false,
        showBackButton: Bool = false,
        showRightButton: Bool = false,
        showAlarmButton: Bool = false,
        hasAlarm: Bool = false,
        rightButtonEnabled: Bool = false,
        backButtonAction: @escaping () -> Void = {},
        rightButtonAction: @escaping () -> Void = {}
    ) {
        self.title = title
        self.rightButtonTitle = rightButtonTitle
        self.showLogo = showLogo
        self.showBackButton = showBackButton
        self.showRightButton = showRightButton
        self.showAlarmButton = showAlarmButton
        self.hasAlarm = hasAlarm
        self.rightButtonEnabled = rightButtonEnabled
        self.backButtonAction = backButtonAction
        self.rightButtonAction = rightButtonAction
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack(alignment: .center) {
            // left button
            HStack {
                if showBackButton {
                    Button(action: backButtonAction) {
                        Image(.icChevronLeft)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                    }
                } else if showLogo {
                    Image(.imgLogoText)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 76, height: 24)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 16)
            
            // title
            if let title = title {
                Text(title)
                    .font(.H6)
                    .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
            // right button
            HStack {
                if showRightButton {
                    Button(action: {
                        if rightButtonEnabled { rightButtonAction() }
                    }, label: {
                        if let title = rightButtonTitle {
                            Text(title)
                                .frame(width: 48, height: 44)
                                .font(.H5)
                                .foregroundColor(
                                    rightButtonEnabled ?
                                    WalkieCommonAsset.blue400.swiftUIColor
                                    : WalkieCommonAsset.gray400.swiftUIColor)
                        }
                    })
                    .padding(.trailing, 10)
                    .disabled(!rightButtonEnabled)
                } else if showAlarmButton {
                    Button(action: rightButtonAction) {
                        Image(hasAlarm ? .icAlertDot : .icAlert)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                    .padding(.trailing, 16)
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .frame(height: 44)
    }
}

// MARK: - Preview

#Preview {
    NavigationBar(
        showLogo: true,
        showAlarmButton: true
    )
    NavigationBar(
        showAlarmButton: true,
        hasAlarm: true
    )
    NavigationBar(
        title: "제목",
        showBackButton: true
    )
    NavigationBar(
        title: "제목",
        rightButtonTitle: "버튼",
        showBackButton: true,
        showRightButton: true
    )
    NavigationBar(
        rightButtonTitle: "버튼",
        showBackButton: true,
        showRightButton: true
    )
    NavigationBar(
        showBackButton: true
    )
}
