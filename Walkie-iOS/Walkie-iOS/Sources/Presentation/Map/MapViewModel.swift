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
    private var destination: CLLocation?
    private var totalDistance: CLLocationDistance?
    
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
            startStepUpdates()
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
        print("✅ back button logic")
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
        
        let startCoordinate = userLoc.coordinate
        let endCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: startCoordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: endCoordinate))
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let route = response?.routes.first {
                print("🚘🚘🚘🚘🚘")
                print(route.distance)
                let contentState = WalkieWidgetAttributes.ContentState(
                    place: name,
                    currentDistance: 0,
                    totalDistance: route.distance
                )
                self.startDynamicIsland(info: contentState)
            } else {
                print("경로 계산 실패:", error ?? "알 수 없는 오류")
            }
        }
    }
}
