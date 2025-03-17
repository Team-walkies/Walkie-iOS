//
//  WalkieWidgetAttributes.swift
//  Walkie-iOS
//
//  Created by ahra on 3/17/25.
//

import ActivityKit

public struct WalkieWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var place: String
        var currentDistance: Double
        var totalDistance: Double
    }
    var name: String
}
