//
//  TextAreaView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 2/11/25.
//

import SwiftUI

struct TextAreaView: View {
    private var limitation: Int
    private var placeholderText: String
    
    @State private var input: String = ""
    @State private var inputState: InputState = .default
    
    init(limitation: Int, placeholderText: String) {
        self.limitation = limitation
        self.placeholderText = placeholderText
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $input)
                .font(.B2)
                .foregroundStyle(.gray700)
                .background(.gray100)
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
                    .foregroundStyle(.gray400)
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
                        .foregroundStyle(.gray400)
                        .padding(.bottom, 16)
                        .padding(.trailing, 16)
                }
            }
        }
        .frame(height: 233)
    }
}
