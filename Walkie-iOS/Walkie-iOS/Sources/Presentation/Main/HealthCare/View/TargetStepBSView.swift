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
    
    @Binding var targetStep: TargetStep
    @State private var initialStep: TargetStep
    @Environment(\.dismiss) private var dismiss
    
    init(targetStep: Binding<TargetStep>) {
        self._targetStep = targetStep
        self._initialStep = State(initialValue: targetStep.wrappedValue)
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
                        targetStep = goal
                    } label: {
                        HStack {
                            let textColor = targetStep == goal
                            ? WalkieCommonAsset.blue400.swiftUIColor
                            : WalkieCommonAsset.gray700.swiftUIColor
                            
                            Text(goal.title)
                                .font(.B1)
                                .foregroundColor(textColor)
                            
                            Spacer()
                            
                            let btnImage: ImageResource = targetStep == goal
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
                isEnabled: targetStep != initialStep,
                buttonAction: {
                    print(targetStep.rawValue)
                    dismiss()
                }
            )
            .padding(.top, 8)
        }
    }
}
