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
        case error(String)
    }
    
    @Published var state: MapViewState
    
    private let pedometer = CMPedometer()
    private var timer: Timer?
    private var activity: Activity<WalkieWidgetAttributes>?
    
    private let locationManager = LocationManager()
    private var totalDistance: CLLocationDistance?
    private var destinationCoord: CLLocationCoordinate2D?
    private var placeName: String = ""
    private var cancellables = Set<AnyCancellable>()
    
    var onPop: (() -> Void)?
    
    @Published var stepData: Int = 0
    @Published var distanceData: Double = 0
    
    init() {
        state = .loading
    }
    
    func action(_ action: Action) {
        switch action {
        case .mapViewAppear:
            startStepUpdates()
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
        }
    }
}

extension MapViewModel {
    
    func setWebURL() throws -> URLRequest {
        let token = (try? TokenKeychainManager.shared.getAccessToken())
        var components = URLComponents(string: Config.webURL)
        components?.queryItems = [
            URLQueryItem(name: "accessToken", value: token),
            URLQueryItem(name: "memberId", value: "6"),
            URLQueryItem(name: "characterRank", value: "1"),
            URLQueryItem(name: "characterType", value: "0"),
            URLQueryItem(name: "characterClass", value: "1")
        ]
        guard let url = components?.url else {
            throw WebURLError.invalidURL
        }
        return URLRequest(url: url)
    }
}

private extension MapViewModel {
    
    func triggerHaptic() {
        print("✅ Triggering haptic feedback")
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    
    func startCountingSteps() {
        print("✅ Starting step counting")
    }
    
    func finishWebView() {
        onPop?()
    }
    
    func startExplore(payload: [String: Any]) {
        print(payload)
        
    }
    
    func sendStep() {
        print("sendstep")
        stopDynamicIsland()
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
                    currentDistance: 0,
                    totalDistance: total
                )
                self.startDynamicIsland(info: state)
            }
        }
        
        self.locationManager.$currentLocation
            .compactMap { $0 }
            .dropFirst()
            .sink { [weak self] newLoc in
                print("🫨🫨🫨🫨")
                print(newLoc)
                self?.updateActivity(with: newLoc)
            }
            .store(in: &self.cancellables)
    }
    
    func updateActivity(with userLoc: CLLocation) {
        print("🫨🫨updateActivity🫨🫨")
        guard
            let dest = destinationCoord,
            let total = totalDistance,
            let activity = activity
        else { return }
        
        let distance = userLoc.distance(
            from: CLLocation(
                latitude: dest.latitude,
                longitude: dest.longitude
            )
        )
        print(distance)
        let updated = WalkieWidgetAttributes.ContentState(
            place: placeName,
            currentDistance: distance,
            totalDistance: total
        )
        print(updated)
        Task {
            await activity.update(ActivityContent(state: updated, staleDate: nil))
        }
    }
}
