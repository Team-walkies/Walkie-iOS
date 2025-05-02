//
//  FormatDistance.swift
//  Walkie-iOS
//
//  Created by 고아라 on 5/2/25.
//

import Foundation

func formatDistance(_ meters: Double) -> String {
    if meters >= 1000 {
        let km = meters / 1000
        let truncated = floor(km * 10) / 10
        if truncated.truncatingRemainder(dividingBy: 1) == 0 {
            return "\(Int(truncated))km"
        } else {
            return "\(truncated)km"
        }
    } else {
        let m = Int(meters)
        return "\(m)m"
    }
}
