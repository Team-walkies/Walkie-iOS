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
            ScrollView {
                VStack(spacing: 16) {
                    switch viewModel.state {
                    case .loaded(let alarmList):
                        ForEach(alarmList, id: \.alarm.id) {
                            AlarmItemView(
                                alarm: $0.alarm.alarmProtocol,
                                timeLapse: $0.timeLapse,
                                showDeleteButton: false)
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
