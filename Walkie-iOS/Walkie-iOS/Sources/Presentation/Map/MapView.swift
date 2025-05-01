//
//  MapView.swift
//  Walkie-iOS
//
//  Created by ahra on 2/24/25.
//

import SwiftUI

import ActivityKit
import WalkieCommon

struct MapView: View {
    
    @ObservedObject var viewModel: MapViewModel
    @State private var activity: Activity<WalkieWidgetAttributes>?
    @State private var request: URLRequest?
    
    var body: some View {
        VStack(spacing: 20) {
            if let request {
                WebView(request: request, viewModel: viewModel)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Text("웹 페이지를 불러올 수 없습니다.")
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            do {
                self.request = try viewModel.setWebURL()
            } catch {
                print("🚨 웹 URL 설정 실패: \(error)")
            }
        }
    }

    func startDynamicIsland() {
        if !ActivityAuthorizationInfo().areActivitiesEnabled {
            print("사용안댐")
            return
        }
        
        if Activity<WalkieWidgetAttributes>.activities.isEmpty {
            let attributes = WalkieWidgetAttributes(name: "ExploreStart")
            let contentState = WalkieWidgetAttributes.ContentState(
                place: "다크그림 신논현역점",
                currentDistance: 660,
                totalDistance: 1000)
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
}
