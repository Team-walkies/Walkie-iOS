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
    
    @State private var input: String = ""
    @State private var inputState: InputState = .default
    @State private var errorMessage: String?
    
    init(limitation: Int, placeholderText: String, onlyText: Bool = false) {
        self.limitation = limitation
        self.placeholderText = placeholderText
        self.onlyText = onlyText
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    TextField(placeholderText, text: self.$input)
                        .padding()
                        .background(.clear)
                        .autocorrectionDisabled(true)
                        .disabled(input.count >= limitation)
                        .font(.B1)
                        .foregroundStyle(inputState.textColor)
                        .onChange(of: input){ oldValue ,newValue in
                            self.inputState = newValue.isEmpty ? .default : .focus
                            if onlyText {
                                filterInput(newValue)
                            }
                        }
                    if !input.isEmpty {
                        Button(action: {
                            input = ""
                            errorMessage = nil
                        }) {
                            Image(.icTextDelete)
                        }
                    }
                }
                Rectangle()
                    .frame(height: 2)
                    .foregroundStyle(inputState.barColor)
                HStack {
                    Text("\(input.count)/\(limitation)")
                        .foregroundStyle(.gray400)
                    Text(errorMessage ?? "")
                        .foregroundStyle(.red100)
                }
            }
        }
    }
    
    private func filterInput(_ newValue: String) {
        let filtered = newValue.unicodeScalars.filter { allowedCharacterSet.contains($0) }
        let filteredString = String(filtered)

        if newValue != filteredString {
            errorMessage = "특수문자 및 기호는 사용할 수 없습니다"
            input = filteredString
        } else {
            errorMessage = nil
        }
    }
}
