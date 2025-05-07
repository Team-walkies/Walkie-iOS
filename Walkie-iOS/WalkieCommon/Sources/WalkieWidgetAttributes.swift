//
//  WalkieWidgetAttributes.swift
//  Walkie-iOS
//
//  Created by ahra on 3/18/25.
//

import ActivityKit

public struct WalkieWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var place: String
        public var leftDistance: Double
        public var totalDistance: Double
        
        public init(place: String, leftDistance: Double, totalDistance: Double) {
            self.place = place
            self.leftDistance = leftDistance
            self.totalDistance = totalDistance
        }
    }
    let name: String
    
    public init(name: String) {
        self.name = name
    }
}
