//
//  AlarmType.swift
//  Walkie-iOS
//
//  Created by ahra on 3/19/25.
//

import SwiftUI

struct AlarmType {
    let id: Int
    let alarmProtocol: AlarmProtocol
}

protocol AlarmProtocol {
    var iconImage: ImageResource { get }
    var alarmTitle: String { get }
    var alarmDescription: String { get }
}

struct SpotAlarm: AlarmProtocol {
    var location: String
    
    var iconImage: ImageResource = .icAlertArrive
    var alarmTitle: String = "스팟 도착"
    var alarmDescription: String {
        "짝짝, \(location)에 도착했어요. 앱에 접속해 알을 얻어보세요."
    }
}

struct EggAlarm: AlarmProtocol {
    var iconImage: ImageResource = .icAlertEgg
    var alarmTitle: String = "알 부화"
    var alarmDescription: String = "희귀 알이 부화하려고 해요!" // EggLiterals 바인딩
}

struct WalkAlarm: AlarmProtocol {
    var step: Int
    
    var iconImage: ImageResource = .icAlertWalk
    var alarmTitle: String = "하루 걸음 수"
    var alarmDescription: String {
        "\(UserManager.shared.getUserNickname)님, 오늘은 \(step)보 걸었어요."
    }
}
