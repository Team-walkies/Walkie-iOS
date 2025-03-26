//
//  NoticeEntity.swift
//  Walkie-iOS
//
//  Created by ahra on 3/24/25.
//

// from server
struct NoticeEntity: Codable {
    let notices: [Notice]
}

struct Notice: Codable {
    let id: Int
    let date, title, detail: String
}

// notice list
struct NoticeListEntity: Codable {
    let noticeList: [NoticeList]
}

struct NoticeList: Codable {
    let id: Int
    let title, date: String
}

extension NoticeEntity {
    
    static func noticeDummy() -> NoticeEntity {
        return NoticeEntity(notices: [
            Notice(id: 1, date: "2025년 3월 25일", title: "안녕하세요! 아요팀입니다ㅏㅏㅏㅏㅏ.", detail: "아요짱 ~ 사과짱 ~"),
            Notice(id: 0, date: "2025년 3월 24일", title: "안녕하세요! 워키팀입니다.", detail: "위얼워키팀\n와우\n와아와우\n와아~")
        ])
    }
    
    func notice(withId id: Int) -> Notice? {
        return notices.first { $0.id == id }
    }
}

extension NoticeListEntity {
    static func from(_ entity: NoticeEntity) -> NoticeListEntity {
        let list = entity.notices.map { NoticeList(id: $0.id, title: $0.title, date: $0.date) }
        return NoticeListEntity(noticeList: list)
    }
    
    static func noticeListDummy() -> NoticeListEntity {
        return from(NoticeEntity.noticeDummy())
    }
}
