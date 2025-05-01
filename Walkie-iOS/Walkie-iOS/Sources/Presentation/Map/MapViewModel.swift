//
//  MapViewModel.swift
//  Walkie-iOS
//
//  Created by ahra on 2/24/25.
//

import SwiftUI

import Combine
import CoreMotion

enum WebURLError: Error {
    case tokenMissing
    case invalidURL
}

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
            startExplore(payload: payload)
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
}

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
