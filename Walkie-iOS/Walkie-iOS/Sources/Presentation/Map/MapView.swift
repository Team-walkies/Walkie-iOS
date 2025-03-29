//
//  MapView.swift
//  Walkie-iOS
//
//  Created by ahra on 2/24/25.
//

import SwiftUI

import ActivityKit
import WalkieCommon
import WebKit

struct MapView: View {
    
    @ObservedObject var viewModel: MapViewModel
    @State private var activity: Activity<WalkieWidgetAttributes>?
    
    let webView = WebView(request: URLRequest(url: URL(string: "http://127.0.0.1:8000/test.html")!))
    
    var body: some View {
        VStack(spacing: 20) {
            Button("다이나믹 아일랜드 시작") {
                startDynamicIsland()
            }
            
            Button("다이나믹 아일랜드 종료") {
                stopDynamicIsland()
            }
            
            webView
                .padding(5)
                .background(.yellow)
                .frame(height: 400)
            
            Button("웹한테 보내기!") {
                webView.sendToWeb()
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
