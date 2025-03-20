//
//  TextAreaView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 2/11/25.
//

import SwiftUI

import WalkieCommon

struct TextAreaView: View {
    private var limitation: Int
    private var placeholderText: String
    
    @Binding var input: String
    @State private var inputState: InputState = .default
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $input)
                .font(.B2)
                .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
                .background(WalkieCommonAsset.gray100.swiftUIColor)
                .autocorrectionDisabled(true)
                .scrollContentBackground(.hidden)
                .multilineTextAlignment(.leading)
                .contentMargins(.horizontal, 12)
                .contentMargins(.top, 6)
                .contentMargins(.bottom, 30)
                .frame(height: 233)
                .onChange(of: input) { oldValue, newValue in
                    self.inputState = newValue.isEmpty ? .default : .focus
                    if newValue.count > limitation {
                        inputState = .error
                        input = oldValue
                    }
                }
                .frame(height: 233)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(inputState.barColor, lineWidth: 1)
                )
            
            if input.isEmpty {
                Text(placeholderText)
                    .font(.B2)
                    .foregroundStyle(WalkieCommonAsset.gray400.swiftUIColor)
                    .padding(.leading, 18)
                    .padding(.top, 15)
                    .allowsHitTesting(false)
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("\(input.count)/\(limitation)")
                        .font(.B2)
                        .foregroundStyle(WalkieCommonAsset.gray400.swiftUIColor)
                        .padding(.bottom, 16)
                        .padding(.trailing, 16)
                }
            }
        }
        .frame(height: 233)
    }
}
