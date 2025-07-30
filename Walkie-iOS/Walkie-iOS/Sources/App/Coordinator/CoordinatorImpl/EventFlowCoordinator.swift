//
//  EventFlowCoordinator.swift
//  Walkie-iOS
//
//  Created by 고아라 on 7/21/25.
//

import Foundation
import Combine

final class EventFlowCoordinator: ObservableObject {
    
    private let remoteConfigManager: RemoteConfigManaging
    private let getEventEggUseCase: GetEventEggUseCase
    
    @Published private(set) var eventEggEntity: EventEggEntity?

    private var cancellables = Set<AnyCancellable>()

    init(
        remoteConfigManager: RemoteConfigManaging = RemoteConfigManager.shared,
        getEventEggUseCase: GetEventEggUseCase
    ) {
        self.remoteConfigManager = remoteConfigManager
        self.getEventEggUseCase  = getEventEggUseCase
    }
    
    func clearEventEntity() {
        self.eventEggEntity = nil
    }

    func checkEvent(completion: (() -> Void)? = nil) {
        Task {
            do {
                try await remoteConfigManager.fetchAndActivate()
                guard remoteConfigManager.boolValue(for: .eggEventEnabled) else { return }

                let now = Date()
                let calendar = Calendar.current
                let oneDayAgo = calendar.date(
                    byAdding: .day, value: -1, to: now
                ) ?? now
                
                let lastDate = UserManager.shared.getLastVisitedDate
                ?? oneDayAgo
                let daysDiff = calendar.dateComponents(
                    [.day],
                    from: calendar.startOfDay(for: lastDate),
                    to: calendar.startOfDay(for: now)
                ).day ?? 0
                
                guard daysDiff >= 1 else { return }
                
                getEventEggUseCase.getEventEgg()
                    .walkieSink(
                        with: self,
                        receiveValue: { _, entity in
                            self.eventEggEntity = entity
                            if entity.canReceive {
                                UserManager.shared.setLastVisitedDate(now)
                            }
                            completion?()
                        },
                        receiveFailure: { _, _ in
                            self.eventEggEntity = nil
                            completion?()
                        }
                    )
                    .store(in: &cancellables)
            } catch {
            }
        }
    }
}
