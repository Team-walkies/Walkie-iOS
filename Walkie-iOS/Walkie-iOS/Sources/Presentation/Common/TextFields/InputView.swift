//
//  InputView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 2/10/25.
//

import SwiftUI

struct InputView: View {
    
    private let allowedCharacterSet = CharacterSet.alphanumerics
    private var limitation: Int
    private var placeholderText: String
    private var onlyText: Bool = false
    
    @Binding var input: String
    @State private var inputState: InputState = .default
    @State private var errorMessage: String?
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                TextField(placeholderText, text: self.$input)
                    .background(.clear)
                    .autocorrectionDisabled(true)
                    .font(.B1)
                    .frame(height: 24)
                    .foregroundStyle(inputState.textColor)
                    .onChange(of: input) { _, newValue in
                        self.inputState = newValue.isEmpty ? .default : .focus
                        if onlyText {
                            filterInput(newValue)
                        }
                        if newValue.count > limitation {
                            input = String(newValue.prefix(limitation))
                            inputState = .error
                        }
                    }
                if !input.isEmpty {
                    Button(action: {
                        input = ""
                        errorMessage = nil
                        inputState = .default
                    }, label: {
                        Image(.icTextDelete)
                            .frame(width: 24, height: 24)
                    })
                }
            }.padding(.bottom, 5)
            Rectangle()
                .frame(height: 2)
                .foregroundStyle(inputState.barColor)
                .padding(.bottom, 11)
            HStack(alignment: .center) {
                Text("\(input.count)/\(limitation)")
                    .foregroundStyle(.gray400)
                    .font(.B1)
                Spacer()
                Text(errorMessage ?? "")
                    .foregroundStyle(.red100)
                    .font(.C1)
            }
        }
    }
    
    private func filterInput(_ newValue: String) {
        let filtered = newValue.unicodeScalars.filter { allowedCharacterSet.contains($0) }
        let filteredString = String(filtered)
        
        if newValue != filteredString {
            errorMessage = StringLiterals.InputView.onlyText
            inputState = .error
        } else {
            errorMessage = nil
        }
    }
}
