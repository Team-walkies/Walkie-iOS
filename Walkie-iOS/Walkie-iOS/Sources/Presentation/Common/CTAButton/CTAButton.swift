//
//  CTAButton.swift
//  Walkie-iOS
//
//  Created by ahra on 2/10/25.
//

import SwiftUI

import WalkieCommon

enum ButtonStyleType {
    case primary
    case danger
    case modal
}

enum ButtonSizeType {
    case large
    case small
    case modal
}

struct CTAButton: View {
    
    // MARK: - Properties
    
    let title: String
    let style: ButtonStyleType
    let size: ButtonSizeType
    let isEnabled: Bool
    let buttonAction: () -> Void
    
    private var backgroundColor: Color {
        switch style {
        case .primary:
            return isEnabled ? WalkieCommonAsset.blue300.swiftUIColor : WalkieCommonAsset.gray200.swiftUIColor
        case .danger:
            return isEnabled ? WalkieCommonAsset.red100.swiftUIColor : WalkieCommonAsset.red50.swiftUIColor
        case .modal:
            return WalkieCommonAsset.gray100.swiftUIColor
        }
    }
    
    private var textColor: Color {
        switch style {
        case .primary:
            return isEnabled ? Color.white : WalkieCommonAsset.gray400.swiftUIColor
        case .danger:
            return Color.white
        case .modal:
            return WalkieCommonAsset.gray500.swiftUIColor
        }
    }
    
    private var height: CGFloat {
        switch size {
        case .large: return 54
        case .small, .modal: return 50
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        Button(
            action: {
                if isEnabled || size == .modal {
                    buttonAction()
                }
            },
            label: {
                Text(title)
                    .font(.B1)
                    .foregroundColor(textColor)
                    .frame(height: height)
                    .frame(maxWidth: .infinity)
                    .background(backgroundColor)
                    .cornerRadius(12)
                    .animation(.easeInOut(duration: 0.2), value: isEnabled)
            }
        )
        .disabled(size == .modal ? false : !isEnabled)
        .padding(.horizontal, 16)
    }
}

// MARK: - Preview

#Preview {
    CTAButton(
        title: "버튼",
        style: .primary,
        size: .large,
        isEnabled: true,
        buttonAction: {})
    CTAButton(
        title: "버튼",
        style: .primary,
        size: .large,
        isEnabled: false,
        buttonAction: {})
    CTAButton(
        title: "버튼",
        style: .danger,
        size: .large,
        isEnabled: true,
        buttonAction: {})
    CTAButton(
        title: "버튼",
        style: .danger,
        size: .large,
        isEnabled: false,
        buttonAction: {})
}
