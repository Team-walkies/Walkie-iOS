//
//  WalkieWidgetLiveActivity.swift
//  WalkieWidget
//
//  Created by ahra on 3/17/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct WalkieWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WalkieWidgetAttributes.self) { context in
            WalkieWidgetProgressView(info: ProgressInfoStruct(
                isLiveActivity: true,
                place: context.state.place,
                currentDistance: context.state.currentDistance,
                totalDistance: context.state.totalDistance)
            )
            .activityBackgroundTint(Color.black)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.trailing) {
                    Image("img_widget_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 76, height: 24)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    WalkieWidgetProgressView(info: ProgressInfoStruct(
                        isLiveActivity: false,
                        place: context.state.place,
                        currentDistance: context.state.currentDistance,
                        totalDistance: context.state.totalDistance)
                    )
                }
            } compactLeading: {
                Image("ic_widget_distance")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
            } compactTrailing: {
                let leftDistance = context.state.totalDistance - context.state.currentDistance
                Text("\(Int(leftDistance))m")
                    .font(.C1)
                    .foregroundColor(.blue200)
            } minimal: {
                Image("ic_widget_distance")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
            }
            .keylineTint(.blue200)
        }
    }
    
}
