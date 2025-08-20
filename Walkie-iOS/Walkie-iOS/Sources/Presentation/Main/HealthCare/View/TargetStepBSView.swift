//
//  TargetStepBSView.swift
//  Walkie-iOS
//
//  Created by 고아라 on 7/14/25.
//

import SwiftUI
import WalkieCommon

enum TargetStep: Int, Identifiable, CaseIterable {
    case four = 4000
    case six = 6000
    case eight = 8000
    case ten = 10000
    
    var id: Int { rawValue }
    
    var title: String {
        rawValue.formatted(.number)
    }
}

struct TargetStepBSView: View {
    
    let changeTarget: (TargetStep) -> Void
    let initialStep: TargetStep
    @State private var selectedStep: TargetStep
    @Environment(\.dismiss) private var dismiss
    
    init(
        targetStep: TargetStep,
        changeTarget: @escaping (TargetStep) -> Void
    ) {
        self.initialStep = targetStep
        _selectedStep = State(initialValue: targetStep)
        self.changeTarget = changeTarget
    }
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            Text("목표 걸음 설정하기")
                .font(.H5)
                .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                .padding(.horizontal, 16)
            
            VStack(
                spacing: 4
            ) {
                ForEach(TargetStep.allCases) { goal in
                    Button {
                        selectedStep = goal
                    } label: {
                        HStack {
                            let textColor = selectedStep == goal
                            ? WalkieCommonAsset.blue400.swiftUIColor
                            : WalkieCommonAsset.gray700.swiftUIColor
                            
                            Text(goal.title)
                                .font(.B1)
                                .foregroundColor(textColor)
                            
                            Spacer()
                            
                            let btnImage: ImageResource = selectedStep == goal
                            ? .btnRadioSelected
                            : .btnRadioUnselected
                            
                            Image(btnImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .padding(.vertical, 2)
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                    }
                    .frame(height: 48)
                    .background(WalkieCommonAsset.gray50.swiftUIColor)
                    .cornerRadius(8, corners: .allCorners)
                }
            }
            .padding(.horizontal, 16)
            
            CTAButton(
                title: "변경하기",
                style: .primary,
                size: .large,
                isEnabled: initialStep != selectedStep,
                buttonAction: {
                    changeTarget(selectedStep)
                    dismiss()
                }
            )
            .padding(.top, 8)
        }
    }
}
