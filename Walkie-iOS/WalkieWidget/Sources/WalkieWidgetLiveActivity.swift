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
            .activityBackgroundTint(Color.white.opacity(0.7))

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.trailing) {
                    Image(.imgWidgetLogo)
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
                Image(.icWidgetDistance)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .foregroundColor(WalkieCommonAsset.blue300.swiftUIColor)
            } compactTrailing: {
                Text(formatDistance(context.state.leftDistance))
                    .font(.C1)
                    .foregroundColor(WalkieCommonAsset.blue200.swiftUIColor)
            } minimal: {
                Image(.icWidgetDistance)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .foregroundColor(WalkieCommonAsset.blue300.swiftUIColor)
            }
            .keylineTint(WalkieCommonAsset.blue200.swiftUIColor)
        }
    }
    
}

