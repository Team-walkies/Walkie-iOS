//
//  AlarmListView.swift
//  Walkie-iOS
//
//  Created by ahra on 3/19/25.
//

import SwiftUI

import WalkieCommon

struct AlarmListView: View {
    
    @ObservedObject var viewModel: AlarmListViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            NavigationBar(
                showBackButton: true
            )
            
            Rectangle()
                .fill(WalkieCommonAsset.gray50.swiftUIColor)
                .frame(height: 36)
                .frame(maxWidth: .infinity)
                .overlay(content: {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            viewModel.action(.tapDeleteButton)
                        }, label: {
                            Text(viewModel.isDeleteMode ? "취소" : "삭제")
                                .font(.B2)
                                .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
                        })
                        .padding(.horizontal, 10)
                        .frame(height: 36)
                    }
                    .padding(.trailing, 16)
                })
                .padding(.bottom, 16)
            
            ScrollView {
                VStack(spacing: 16) {
                    switch viewModel.state {
                    case .loaded(let alarmList):
                        ForEach(alarmList, id: \.alarm.id) { item in
                            AlarmItemView(
                                alarm: item.alarm.alarmProtocol,
                                timeLapse: item.timeLapse,
                                showDeleteButton: viewModel.isDeleteMode,
                                tapDelete: {
                                    viewModel.action(.tapDeleteAlarm(id: item.alarm.id))
                                })
                        }
                    case .error(let message):
                        Text(message)
                    default:
                        ProgressView()
                    }
                }
            }
        }
        .onAppear {
            viewModel.action(.alarmListWillAppear)
        }
    }
}

#Preview {
    AlarmListView(viewModel: AlarmListViewModel())
}
