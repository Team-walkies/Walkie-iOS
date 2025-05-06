//
//  MapViewModel.swift
//  Walkie-iOS
//
//  Created by ahra on 2/24/25.
//

import SwiftUI

import Combine
import CoreMotion
import ActivityKit
import WalkieCommon
import MapKit

final class MapViewModel: ViewModelable {
    
    enum Action {
        case mapViewAppear
        case mapViewDisappear
    }
    
    struct MapState {
        let step: Int
        let distance: Double
    }
    
    enum MapViewState {
        case loading
        case loaded(MapState)
        case error
    }
    
    @Published var state: MapViewState
    
    private let pedometer = CMPedometer()
    private var timer: Timer?
    private var activity: Activity<WalkieWidgetAttributes>?
    
    private let locationManager = LocationManager()
    private var totalDistance: CLLocationDistance?
    private var destinationCoord: CLLocationCoordinate2D?
    private var placeName: String = ""
    private var lastLocation: CLLocation?
    private var lastLeftDistance: CLLocationDistance?
    
    private var cancellables = Set<AnyCancellable>()
    private var locationCancellable: AnyCancellable?
    
    var onPop: (() -> Void)?
    var sendToWeb: ((Int) -> Void)?
    
    @Published var stepData: Int = 0
    @Published var distanceData: Double = 0
    @Published var exploreStep: Int = 1234
    @Published var webRequest: URLRequest?
    
    private let getCharacterPlayUseCase: GetCharacterPlayUseCase
    
    init(
        getCharacterPlayUseCase: GetCharacterPlayUseCase
    ) {
        state = .loading
        self.getCharacterPlayUseCase = getCharacterPlayUseCase
    }
    
    func action(_ action: Action) {
        switch action {
        case .mapViewAppear:
            getCharacterPlay()
        case .mapViewDisappear:
            stopStepUpdates()
        }
    }
    
    func handleWebMessage(_ message: WebMessage) {
        switch message.type {
        case .haptic:
            triggerHaptic()
        case .startCountingSteps:
            break
        case .finishWebView:
            finishWebView()
        case .startExplore:
            guard let payload = message.payload else { return }
            calculateTotal(payload: payload)
        case .getStepsFromMobile:
            sendStep()
        case .stopExplore:
            stopDynamicIsland()
        }
    }
}

extension MapViewModel {
    
    func getCharacterPlay() {
        getCharacterPlayUseCase.getCharacterPlay()
            .walkieSink(
                with: self,
                receiveValue: { _, entity in
                    do {
                        self.webRequest = try self.setWebURL(entity: entity)
                    } catch {
                        print("🚨 웹 URL 설정 실패: \(error)")
                    }
                }, receiveFailure: { _, _ in
                    self.state = .error
                }
            )
            .store(in: &cancellables)
    }
    
    func setWebURL(entity: CharactersPlayEntity) throws -> URLRequest {
        let token = (try? TokenKeychainManager.shared.getAccessToken())
        print("🫨🫨🫨🫨🫨🫨")
        print(token)
        var components = URLComponents(string: Config.webURL)
        components?.queryItems = [
            URLQueryItem(name: "accessToken", value: token),
            URLQueryItem(name: "memberId", value: "6"),
            URLQueryItem(name: "characterRank", value: "\(entity.characterRank)"),
            URLQueryItem(name: "characterType", value: "\(entity.characterType)"),
            URLQueryItem(name: "characterClass", value: "\(entity.characterClass)")
        ]
        guard let url = components?.url else {
            throw WebURLError.invalidURL
        }
        return URLRequest(url: url)
    }
}

private extension MapViewModel {
    
    func triggerHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    
    func startCountingSteps() {
        print("✅ Starting step counting")
    }
    
    func finishWebView() {
        onPop?()
        stopDynamicIsland()
    }
    
    func startExplore(payload: [String: Any]) {
        print(payload)
        
    }
    
    func sendStep() {
        print("sendstep")
        sendToWeb?(exploreStep)
        updateArriveActivity()
        
        locationCancellable?.cancel()
        locationCancellable = nil
    }
}

// step
private extension MapViewModel {
    
    func startStepUpdates() {
        guard CMPedometer.isStepCountingAvailable() else { return }
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.pedometer.startUpdates(from: startOfDay) { data, error in
                guard let self = self else { return }
                
                if let data = data, error == nil {
                    DispatchQueue.main.async {
                        let newStepData = data.numberOfSteps.intValue
                        let newDistanceData = (data.distance?.doubleValue ?? 0.0) / 1000.0
                        self.updateStepData(step: newStepData, distance: newDistanceData)
                    }
                }
            }
        }
    }
    
    func stopStepUpdates() {
        timer?.invalidate()
        timer = nil
        pedometer.stopUpdates()
    }
    
    func updateStepData(step: Int, distance: Double) {
        let mapState = MapState(step: step, distance: distance)
        state = .loaded(mapState)
    }
}

// dynamic island
private extension MapViewModel {
    
    func startDynamicIsland(info: WalkieWidgetAttributes.ContentState) {
        
        if !ActivityAuthorizationInfo().areActivitiesEnabled {
            print("사용안댐")
            return
        }
        
        if Activity<WalkieWidgetAttributes>.activities.isEmpty {
            let attributes = WalkieWidgetAttributes(name: "ExploreStart")
            let contentState = info
            let content = ActivityContent(state: contentState, staleDate: nil)
            
            do {
                activity = try Activity<WalkieWidgetAttributes>.request(
                    attributes: attributes,
                    content: content,
                    pushType: nil
                )
                print("다이나믹 아일랜드 시작됨: \(activity?.id ?? "없음")")
            } catch {
                print("다이나믹 아일랜드 시작 실패: \(error)")
            }
        } else {
            print("이미 다이나믹 아일랜드가 실행 중입니다.")
        }
    }
    
    func stopDynamicIsland() {
        let activities = Activity<WalkieWidgetAttributes>.activities
        if activities.isEmpty {
            print("종료할 다이나믹 아일랜드가 없습니다.")
            return
        }
        
        for activeActivity in activities {
            Task {
                let finalContent = ActivityContent(state: activeActivity.content.state, staleDate: nil)
                await activeActivity.end(finalContent, dismissalPolicy: .immediate)
                print("다이나믹 아일랜드 종료됨: \(activeActivity.id)")
            }
        }
        activity = nil
    }
    
    func calculateTotal(payload: [String: Any]) {
        guard
            let name = payload["name"] as? String,
            let lat  = payload["lat"]  as? Double,
            let lng  = payload["lng"]  as? Double,
            let userLoc = locationManager.currentLocation
        else { return }
        placeName = name
        
        let startCoord = userLoc.coordinate
        let endCoord = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        destinationCoord = endCoord
        
        DistanceService.calculateRouteDistance(
            from: startCoord,
            to: endCoord
        ) { [weak self] distance in
            DispatchQueue.main.async {
                guard let self = self, let total = distance else { return }
                self.totalDistance = total
                let state = WalkieWidgetAttributes.ContentState(
                    place: name,
                    leftDistance: total,
                    totalDistance: total
                )
                self.startDynamicIsland(info: state)
            }
        }
        
        locationCancellable = self.locationManager.$currentLocation
            .compactMap { $0 }
            .dropFirst()
            .sink { [weak self] newLoc in
                print("🫨🫨🫨🫨")
                print(newLoc)
                self?.updateActivity(with: newLoc)
            }
    }
    
    func updateActivity(with userLoc: CLLocation) {
        print("😑😑userLoc😑😑", userLoc)
        print("🫨🫨updateActivity🫨🫨")
        guard userLoc.horizontalAccuracy <= 20 else {
            print("❌ 무시: 정확도 너무 낮음 (\(userLoc.horizontalAccuracy)m)")
            return
        }
        
        guard
            let dest = destinationCoord,
            let total = totalDistance,
            let activity = activity
        else { return }
        
        DistanceService.calculateRouteDistance(
            from: userLoc.coordinate,
            to: dest
        ) { [weak self] distance in
            guard let self = self, let distance = distance else {
                print("❌ 거리 계산 실패")
                return
            }
            
            if let last = self.lastLocation {
                let moved = userLoc.distance(from: last)
                if moved < 10 {
                    print("🚫 무시: 이동 거리 작음 (\(moved)m)")
                    return
                }
            }
            
            if self.lastLeftDistance != nil {
                let diff = abs(self.lastLeftDistance! - distance)
                if diff < 5 {
                    print("⏸️ 무시: 남은 거리 변화 작음 (\(diff)m)")
                    return
                }
            }
            
            print("📍 유효 위치 갱신 거리: \(distance)m")
            
            let updated = WalkieWidgetAttributes.ContentState(
                place: self.placeName,
                leftDistance: distance,
                totalDistance: total
            )
            print(updated)
            Task {
                await activity.update(ActivityContent(state: updated, staleDate: nil))
            }
            
            self.lastLocation = userLoc
            self.lastLeftDistance = distance
        }
    }
    
    func updateArriveActivity() {
        guard
            let total = totalDistance,
            let activity = activity
        else { return }
        
        let updated = WalkieWidgetAttributes.ContentState(
            place: self.placeName,
            leftDistance: 0,
            totalDistance: total
        )
        print(updated)
        Task {
            await activity.update(ActivityContent(state: updated, staleDate: nil))
        }
    }
}
