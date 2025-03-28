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
    @ObservedObject private var webViewModel = WalkieWebViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Button("다이나믹 아일랜드 시작") {
                startDynamicIsland()
            }
            
            Button("다이나믹 아일랜드 종료") {
                stopDynamicIsland()
            }
            
            Button(action: {
                webViewModel.sendMessageToWeb(completionHandler: {_,_ in 
                    print("메시지 전송 완료")
                })
            }, label: {
                Text("웹에 메시지 전송")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            })
            
            VStack {
                if webViewModel.shouldLoadWebView, let url = webViewModel.webViewURL {
                    WebView(url: url, viewModel: webViewModel)
                        .frame(maxWidth: 300, maxHeight: 400)
                    Text("받은 메시지: \(webViewModel.receivedMessage)")
                } else {
                    Text("HTML 파일 로드 중...")
                }
            }
        }
        .onAppear {
            webViewModel.loadLocalHTML()
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
