//
//  WalkieResponse.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/1/25.
//

import Foundation

struct WalkieResponse<ResponseType: Decodable>: Decodable {
    let success: Bool
    let message: String
    let data: ResponseType?
}
