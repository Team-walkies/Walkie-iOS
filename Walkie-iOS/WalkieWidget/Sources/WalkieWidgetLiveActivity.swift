//
//  Walkie_WidgetLiveActivity.swift
//  Walkie-Widget
//
//  Created by ahra on 3/18/25.
//

import ActivityKit
import WidgetKit
import SwiftUI
import WalkieCommon

struct WalkieWidgetLiveActivity: Widget {
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WalkieWidgetAttributes.self) { context in
            WalkieWidgetProgressView(info: ProgressInfoStruct(
                isLiveActivity: true,
                place: context.state.place,
                leftDistance: context.state.leftDistance,
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
                        leftDistance: context.state.leftDistance,
                        totalDistance: context.state.totalDistance)
                    )
                }
            } compactLeading: {
                Image("ic_widget_distance")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
            } compactTrailing: {
                Text(formatDistance(context.state.leftDistance))
                    .font(.C1)
                    .foregroundColor(WalkieCommonAsset.blue200.swiftUIColor)
            } minimal: {
                Image("ic_widget_distance")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
            }
            .keylineTint(WalkieCommonAsset.blue200.swiftUIColor)
        }
    }
    
}

