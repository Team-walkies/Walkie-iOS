//
//  AlarmListViewModel.swift
//  Walkie-iOS
//
//  Created by ahra on 3/19/25.
//

import SwiftUI

import Combine

final class AlarmListViewModel: ViewModelable {
    
    @Published var state: AlarmListViewState = .loading
    
    enum Action {
        case alarmListWillAppear
        case tapDeleteButton
        case tapDeleteAlarm(id: Int)
    }
    
    struct AlarmListState {
        let alarm: AlarmType
        let timeLapse: String
    }
    
    enum AlarmListViewState {
        case loading
        case loaded([AlarmListState])
        case error(String)
    }
    
    func action(_ action: Action) {
        switch action {
        case .alarmListWillAppear:
            getAlarmList()
        default:
            break
        }
    }
    
    func getAlarmList() {
        let alarmList: [AlarmListState] = [
            AlarmListState(alarm: AlarmType(id: 1, alarmProtocol: SpotAlarm(location: "여의도한강공원")), timeLapse: "31분"),
            AlarmListState(alarm: AlarmType(id: 2, alarmProtocol: EggAlarm()), timeLapse: "1시간"),
            AlarmListState(alarm: AlarmType(id: 3, alarmProtocol: SpotAlarm(location: "우리집")), timeLapse: "21시간"),
            AlarmListState(alarm: AlarmType(id: 4, alarmProtocol: WalkAlarm(step: 2345)), timeLapse: "1일"),
            AlarmListState(alarm: AlarmType(id: 5, alarmProtocol: SpotAlarm(location: "집에가고싶다")), timeLapse: "1주"),
            AlarmListState(alarm: AlarmType(id: 6, alarmProtocol: WalkAlarm(step: 1221)), timeLapse: "1달")
        ]
        state = .loaded(alarmList)
    }
}
