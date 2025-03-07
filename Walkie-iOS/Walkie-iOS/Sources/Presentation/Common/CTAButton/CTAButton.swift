//
//  CTAButton.swift
//  Walkie-iOS
//
//  Created by ahra on 2/10/25.
//

import SwiftUI

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
            return isEnabled ? .blue300 : .gray200
        case .danger:
            return isEnabled ? .red100 : .red50
        case .modal:
            return .gray100
        }
    }
    
    private var textColor: Color {
        switch style {
        case .primary:
            return isEnabled ? .white : .gray400
        case .danger:
            return .white
        case .modal:
            return .gray500
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
