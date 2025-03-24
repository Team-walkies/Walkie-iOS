//
//  NoticeViewModel.swift
//  Walkie-iOS
//
//  Created by ahra on 3/24/25.
//

import SwiftUI

import Combine

final class NoticeViewModel: ViewModelable {
    
    @Published var state: NoticeViewState = .loading
    @Published var detailState: NoticeDetailViewState = .loading
    @Published var id: Int = 0
    
    enum Action {
        case noticeAppear
        case tapDetailButton(id: Int)
        case noticeDetailAppear
    }
    
    struct NoticeState {
        let noticeList: NoticeListEntity
    }
    
    struct NoticeDetailState {
        let noticeDetail: Notice
    }
    
    enum NoticeViewState {
        case loading
        case loaded(NoticeState)
        case error(String)
    }
    
    enum NoticeDetailViewState {
        case loading
        case loaded(NoticeDetailState)
        case error(String)
    }
    
    func action(_ action: Action) {
        switch action {
        case .noticeAppear:
            getNoticeList()
        case .tapDetailButton(id: let id):
            print("tapNoticeId: \(id)")
            self.id = id
        case .noticeDetailAppear:
            getNoticeDetail(id: id)
        }
    }
    
    func getNoticeList() {
        let noticeList = NoticeState(noticeList: NoticeListEntity.noticeListDummy())
        state = .loaded(noticeList)
    }
    
    func getNoticeDetail(id: Int) {
        if let noticeDetail = NoticeEntity.noticeDummy().notice(withId: 1) {
            detailState = .loaded(NoticeDetailState(noticeDetail: noticeDetail))
        }
    }
}
