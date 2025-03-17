//
//  WalkieWidgetLiveActivity.swift
//  WalkieWidget
//
//  Created by ahra on 3/17/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

public struct WalkieWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var stepCount: Int
    }
    var name: String
}

struct WalkieWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WalkieWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.stepCount)")
                    .font(.B2)
                    .foregroundColor(.blue300)
            }
            .activityBackgroundTint(Color.black)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.stepCount)")
                }
            } compactLeading: {
                Image("ic_widget_distance")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
            } compactTrailing: {
                Text("340m")
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
