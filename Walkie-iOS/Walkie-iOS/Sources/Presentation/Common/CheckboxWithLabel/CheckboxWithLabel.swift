//
//  CheckboxWithLabel.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/1/25.
//

import SwiftUI

struct CheckboxWithLabel: View {
    @Binding var isChecked: Bool
    let text: String
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            Button(action: {
                self.isChecked.toggle()
            }, label: {
                Image(isChecked ? .icCheckboxChecked : .icCheckboxUnchecked)
            }).frame(width: 28, height: 28)
            Text(text)
                .font(.B2)
                .foregroundStyle(isChecked ? .gray700 : .gray500)
        }
    }
}
