//
//  Array+.swift
//  Walkie-iOS
//
//  Created by ahra on 2/20/25.
//

extension Array {
    
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
