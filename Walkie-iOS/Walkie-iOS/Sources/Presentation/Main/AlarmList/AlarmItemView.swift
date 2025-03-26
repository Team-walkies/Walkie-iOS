//
//  AlarmItemView.swift
//  Walkie-iOS
//
//  Created by ahra on 3/19/25.
//

import SwiftUI

import WalkieCommon

struct AlarmItemView: View {
    
    let alarm: AlarmProtocol
    let timeLapse: String
    let showDeleteButton: Bool
    let tapDelete: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(alarm.iconImage)
                .resizable()
                .scaledToFit()
                .frame(width: 42, height: 42)
                .padding(.leading, 16)
            
            VStack(spacing: 4) {
                HStack {
                    Text(alarm.alarmTitle)
                        .font(.H6)
                        .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                    
                    Spacer()
                    
                    if showDeleteButton {
                        Button(action: {
                            tapDelete()
                        }, label: {
                            Image(.icClose)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                        })
                    } else {
                        Text("\(timeLapse) 전")
                            .font(.C1)
                            .foregroundColor(WalkieCommonAsset.gray400.swiftUIColor)
                    }
                }
                .frame(maxWidth: .infinity)
                
                Text(alarm.alarmDescription)
                    .font(.B2)
                    .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
                    .alignTo(.leading)
                    .frame(maxWidth: .infinity)
            }
            .padding(.trailing, 16)
        }
        .padding(.top, 8)
        .padding(.bottom, 8)
    }
}
