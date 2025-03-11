//
//  WalkieResponse.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/1/25.
//

import Foundation

struct WalkieResponse<ResponseType: Decodable>: Decodable {
    var status: Int
    var message: String
    var data: ResponseType?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case data
    }
    
    init(status: Int, message: String, data: ResponseType?) {
        self.status = status
        self.message = message
        self.data = data
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = (try? values.decode(Int.self, forKey: .status)) ?? 0
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        data = (try? values.decode(ResponseType.self, forKey: .data)) ?? nil
    }
}
